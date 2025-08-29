#include <Wire.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <ESP32Servo.h>
#include <WiFiClientSecure.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ESPSupabase.h>


// WiFi settings
const char* ssid = "Shahin It";
const char* password = "EntranceShahinN9000";

// HiveMQ settings
const char* mqtt_server = "fad80a4f45ea4d52a130bb076c4f09c2.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_user = "Loayy";
const char* mqtt_password = "Pin135798642";
const char* mqtt_pub_topic = "sensor/UltraSonic";
const char* mqtt_sub_topic = "servo/control";

Supabase Final_Project;

// Supabase credentials
String supabase_url = "https://ltsjkbibmlvyzavzsptl.supabase.co";
String anon_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0c2prYmlibWx2eXphdnpzcHRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNzQ0NzcsImV4cCI6MjA3MTk1MDQ3N30.oZttHnze4U3NXxI2uaaHdYbuoGKH-l5B7y3277I4OW8";

// Table
String table = "parking";

// Pins
const int ledPin = 15;
const int buzzerPin = 2;
const int ServoPin = 13;
const int PIR_PIN = 5;
const int trigPin = 26;
const int echoPin = 25;

// LCD
LiquidCrystal_I2C lcd(0x27, 16, 2);
Servo myservo;

// MQTT client
WiFiClientSecure secureClient;
PubSubClient client(secureClient);

// States
enum State { WAITING, GATE_OPEN, PARKING, STOPPED };
State systemState = WAITING;

// --- MQTT Callback ---
void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String msg;
  for (int i = 0; i < length; i++) {
    msg += (char)payload[i];
  }
  msg.trim();

  Serial.print("Message received [");
  Serial.print(topic);
  Serial.print("]: ");
  Serial.println(msg);

  // Control servo via MQTT
  if (msg == "OPEN") {
    myservo.write(90);
    Serial.println("Servo opened via MQTT");
    systemState = GATE_OPEN;   // force into gate open state
  } 
  else if (msg == "CLOSE") {
    myservo.write(0);
    Serial.println("Servo closed via MQTT");
    systemState = WAITING;     // reset system to WAITING mode
  }
}

// --- MQTT Reconnect ---
void reconnect() {
  while (!client.connected()) {
    Serial.println("Attempting MQTT connection...");
    if (client.connect("ESP32Client", mqtt_user, mqtt_password)) {
      Serial.println("MQTT connected");
      client.subscribe(mqtt_sub_topic);
    } else {
      Serial.print("Failed. State=");
      Serial.println(client.state());
      delay(5000);
    }
  }
}

// --- Distance Function ---
float getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);
  float distance = duration * 0.034 / 2; // cm
  return distance;
}


void setup() {
  Serial.begin(115200);

  pinMode(ledPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
  pinMode(PIR_PIN, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  myservo.attach(ServoPin);

  // Connect WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    Serial.print(".");
  }
  Serial.println(" WiFi Connected!");

  // Connect to supabase
  Final_Project.begin(supabase_url, anon_key);


  // Connect MQTT
  secureClient.setInsecure(); // insecure for testing
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(mqttCallback);

  Wire.begin(21, 22);
  lcd.init();
  lcd.backlight();

  lcd.setCursor(0, 0);
  lcd.print("Parking System");
  delay(2000);
  lcd.clear();
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop(); // handle MQTT messages

  int pirValue = digitalRead(PIR_PIN);  
  switch (systemState) {
    case WAITING:
      myservo.write(0);
      digitalWrite(buzzerPin, LOW);
      digitalWrite(ledPin, LOW);

      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Waiting...");
      Serial.println("No Motion");

      if (pirValue == LOW) {
        systemState = GATE_OPEN;
      }
      break;

    case GATE_OPEN:
      Serial.println("Motion Detected!");
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Motion Detected");

      myservo.write(90); 
      Serial.println("Gate Open");
      lcd.setCursor(0, 1);
      lcd.print("Gate is Open");

      delay(2000); 
      systemState = PARKING;
      break;

    case PARKING: {
      float distance = getDistance();
      Serial.print("Distance: ");
      Serial.print(distance);
      Serial.println(" cm");

      // Publish distance to MQTT
      char msg[50];
      snprintf(msg, sizeof(msg), "%.2f", distance);
      client.publish(mqtt_pub_topic, msg);

      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Dist: ");
      lcd.print(distance);
      lcd.print("cm");

      if (distance <= 10 && distance > 0) {
        systemState = STOPPED;
      }
      break;
    }


    case STOPPED:
      digitalWrite(buzzerPin, HIGH);
      digitalWrite(ledPin, HIGH);

      lcd.setCursor(0, 1);
      lcd.print("STOP !!");
      Serial.println("STOP !!");
      delay(2000);
      systemState = WAITING;
      break;
  }

  delay(500);
}
