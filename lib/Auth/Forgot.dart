import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  String? errorMessage = '';

  final TextEditingController _emailController = TextEditingController();

  Future<void> sendPasswordResetEmail() async {
    try {
      await Auth().sendPasswordResetEmail(
        email: _emailController.text,
      );
      // display success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reset Password'),
            content: Text('Email has been sent to ${_emailController.text}.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFF1F1F1), // Set the background color of the entire screen
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Email Text Field with Human Icon and Placeholder
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
                hintText: 'orlandgeronimo@gmail.com',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            // Next Button
            ElevatedButton(
              onPressed: sendPasswordResetEmail,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFF1F1F1)),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16.0),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                      fontFamily: 'NanumGothic', // Custom Font
                      fontSize: 18),
                ),
                foregroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 51, 51, 51)), // Set text color to white
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Set corner radius to 0
                  ),
                ),
                elevation: MaterialStateProperty.all(4), // Add shadow
              ),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
