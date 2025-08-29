import 'package:flutter/material.dart';
import 'package:garage_iot/Ultrasonic%20Reading/MQTTUltra.dart';

class Ultrasonic extends StatefulWidget {
  const Ultrasonic({super.key});

  @override
  State<Ultrasonic> createState() => _UltrasonicState();
}

class _UltrasonicState extends State<Ultrasonic> {
  bool canPark = false;
  MQTTClientWrapper sensorMonitorClient = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
    sensorMonitorClient.onReadingUpdate = (String newReading) {
      setState(() {
        canPark = double.tryParse(newReading) != null && double.parse(newReading) > 0 && double.parse(newReading) <= 10;
        sensorMonitorClient.currentReading = newReading; 
      });
    };
    sensorMonitorClient.prepareMqttClient();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Ultrasonic Sensor')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blueAccent, 
                borderRadius: BorderRadius.circular(15), 
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Text(
                  "Ultrasonic Sensor Data",
                  style: TextStyle(fontSize: 25, color: Colors.white)
                ),
              )
            ),
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: canPark ? Colors.orange : Colors.green, 
                borderRadius: BorderRadius.circular(15), 
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Text(
                  canPark ? "You can stop now." : "Keep moving into the garage.",
                  style: TextStyle(fontSize: 28, color: Colors.white)
                ),
              )
            ),
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blueAccent, 
                borderRadius: BorderRadius.circular(15), 
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Text(
                  "Distance: ${sensorMonitorClient.currentReading} cm",
                  style: TextStyle(fontSize: 30, color: Colors.white)
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}