import 'package:flutter/material.dart';
import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> login(String username, String password) async {
    try {
      await supabase.from('parking').insert({
        'username': username,
        'password': password,
        'action': 'login',
        'time': DateTime.now().toIso8601String(),
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_parking, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "IoT Smart Parking",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.black), // black text
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.blue),
                  enabledBorder: OutlineInputBorder( borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12), ),
                 focusedBorder: OutlineInputBorder( borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                        ),
                    ), 
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black), // black text
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.blue),
                  enabledBorder: OutlineInputBorder( borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12), ),
                  focusedBorder: OutlineInputBorder( borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                        ),
                    ), 
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  current_user = usernameController.text.trim();
                  current_password = passwordController.text.trim();
                  login(usernameController.text.trim(),
                      passwordController.text.trim());
                },
                child: const Text("Login",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}