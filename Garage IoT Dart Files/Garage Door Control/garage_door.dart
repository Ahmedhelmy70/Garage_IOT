import 'package:flutter/material.dart';
import 'package:garage_iot/Garage Door Control/MQTTControl.dart';
import '../../main.dart'; // To access `current_user` and `supabase`

class GarageDoorControl extends StatefulWidget {
  const GarageDoorControl({super.key});

  @override
  State<GarageDoorControl> createState() => _GarageDoorControlState();
}

class _GarageDoorControlState extends State<GarageDoorControl> {

  bool isGarageDoorOpen = false;
  MQTTClientWrapper servoControlClient = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
    servoControlClient.prepareMqttClient();
  }

  Future<void> logGarageAction(String action) async {
    await supabase.from('parking').insert({
      'username': current_user,
      'password': current_password,
      'action': action,
      'time': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Text('Garage Door Control'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Current Garage Status: ${isGarageDoorOpen ? "Open" : "Closed"}', style: TextStyle(fontSize: 26, color: Colors.white)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 30),
                  backgroundColor: Colors.green,
                  fixedSize: Size(300, 200)
                ),
                onPressed: () async {
                  setState(() {
                    isGarageDoorOpen = true;
                  });
                  servoControlClient.publishMessage('OPEN');
                  await logGarageAction('Door Opened');
                  print('Garage door has been opened');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward, size: 40),
                    SizedBox(width: 8),
                    Text('Open'),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 30),
                  backgroundColor: Colors.red,
                  fixedSize: Size(300, 200)
                ),
                onPressed: () async {
                  setState(() {
                    isGarageDoorOpen = false;
                  });
                  servoControlClient.publishMessage('CLOSE');
                  await logGarageAction('Door Closed');
                  print('Garage door has been closed');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_downward, size: 40),
                    SizedBox(width: 8),
                    Text('Close'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}