import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../Auth/registration_screen.dart'; // Ensure this file exists
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Auth/auth.dart';
import 'package:main/Auth/forgot.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMessage = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: title,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : ' $errorMessage',
      style: const TextStyle(
        color: Colors.red, // Set error message color to red
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: signInWithEmailAndPassword,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFF1F1F1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
          horizontal: 140.0,
          vertical: 16.0,
        )),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
              fontFamily: 'NanumGothic', // Custom Font
              fontSize: 16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide.none, // Remove the border
          ),
        ),
        elevation: MaterialStateProperty.all(2), // Add shadow
      ),
      child: const Text('Login'),
    );
  }

  Widget _forgotPassword() {
    return RichText(
      text: TextSpan(
        text: 'Forgot Password?',
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 15.0,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPage()),
            );
          },
      ),
    );
  }

  Widget _registerLink() {
    return RichText(
      text: TextSpan(
        text: 'No account? ',
        style: const TextStyle(
          fontSize: 13.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Click here to register',
            style: const TextStyle(
              color: Colors.blue,
              fontStyle: FontStyle.italic,
              fontSize: 15.0,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo
              Image.asset(
                'assets/images/ingreicon.jpg', // Make sure you have this image in the assets folder
                height: 200,
              ),
              const SizedBox(height: 20),
              // IngreChef Text
              const Text(
                'IngreChef',
                style: TextStyle(
                  fontFamily: 'GreatVibes',
                  fontSize: 60,
                ),
              ),
              const SizedBox(height: 40),
              // Username Text Field
              _entryField('Email', _emailController),
              const SizedBox(height: 20),
              // Password Text Field
              _entryField(
                'Password',
                _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              // Forgot Password and Register Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _forgotPassword(),
                  _registerLink(),
                ],
              ),
              _errorMessage(),
              const SizedBox(height: 10),
              // Login Button
              _submitButton()
            ],
          ),
        ),
      ),
    );
  }
}
