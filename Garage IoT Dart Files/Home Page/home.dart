import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/garage');
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 30),
              fixedSize: Size(350, 100)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.garage_rounded, size: 40),
                SizedBox(width: 8),
                Text('Garage Control'),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/parking');
            }, style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 30),
              fixedSize: Size(350, 100)
            ), 
            child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_parking, size: 40),
                    SizedBox(width: 8),
                    Text('Parking Sensor'),
                  ],
                ),
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/history');
            }, style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 30),
              fixedSize: Size(350, 100)
            ),
            child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 40),
                    SizedBox(width: 8),
                    Text('Parking History'),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}