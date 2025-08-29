import 'package:flutter/material.dart';
import 'Garage Door Control/garage_door.dart';
import 'Ultrasonic Reading/ultrasonic.dart';
import 'Home Page/home.dart';
import 'Login Page/login.dart';
import 'History Page/history.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
String current_user = '';
String current_password = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
    await Supabase.initialize(
      url: 'https://ltsjkbibmlvyzavzsptl.supabase.co', // 🔹 Replace with your Supabase URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0c2prYmlibWx2eXphdnpzcHRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNzQ0NzcsImV4cCI6MjA3MTk1MDQ3N30.oZttHnze4U3NXxI2uaaHdYbuoGKH-l5B7y3277I4OW8', // 🔹 Replace with your Supabase anon/public key
    );
  runApp(Main());

}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garage IoT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => Home(),
        '/garage': (context) => GarageDoorControl(),
        '/parking': (context) => Ultrasonic(),
        '/history': (context) => HistoryPage(),
      },
    );
  }
}