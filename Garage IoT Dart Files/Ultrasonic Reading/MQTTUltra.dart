/*
 * Copyright 2021 HiveMQ GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

main() {
  MQTTClientWrapper newclient = MQTTClientWrapper();
  newclient.prepareMqttClient();
}

// connection states for easy identification
enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  errorWhenConnecting
}

enum MqttSubscriptionState {
  idle,
  subscribed
}

class MQTTClientWrapper {
  late MqttServerClient client;
  String currentReading = '400.0';
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.idle;

  Function(String)? onReadingUpdate;

  Future<void> prepareMqttClient() async {
    setupMqttClient();
    await connectClient();
    subscribeToTopic('sensor/UltraSonic');
  }

  Future<void> connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.connecting;
      await client.connect('Loayy', 'Pin135798642');
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.connected;
      print('client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }
  }

  void setupMqttClient() {
    client = MqttServerClient.withPort(
        'fad80a4f45ea4d52a130bb076c4f09c2.s1.eu.hivemq.cloud', 'Loay', 8883);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
  }

  void subscribeToTopic(String topicName) {
    client.subscribe(topicName, MqttQos.atMostOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      currentReading = message;

      if (onReadingUpdate != null) {
        onReadingUpdate!(message);
      }

      print('YOU GOT A NEW MESSAGE:');
      print(message);
    });
  }

  void publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print(
        'Publishing message "$message" to topic sensor/UltraSonic');
    if (builder.payload != null) {
      client.publishMessage(
          'sensor/UltraSonic', MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.subscribed;
  }

  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.disconnected;
  }

  void onConnected() {
    connectionState = MqttCurrentConnectionState.connected;
    print('OnConnected client callback - Client connection was successful');
  }


}