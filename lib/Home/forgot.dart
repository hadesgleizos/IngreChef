import 'package:flutter/material.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    void _resetPassword() {
      // implement the password reset functionality here
      // for example, you might want to call Firebase's password reset function
      final String email = _emailController.text;
      // perform password reset operation
      // example: FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }

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
              onPressed: _resetPassword,
              child: const Text('Next'),
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
                    Color.fromARGB(255, 51, 51, 51)), // Set text color to white
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Set corner radius to 0
                  ),
                ),
                elevation: MaterialStateProperty.all(4), // Add shadow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
