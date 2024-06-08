import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../Auth/registration_screen.dart'; // Ensure this file exists
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Auth/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  String? errorMessage = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: title,
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed:
        signInWithEmailAndPassword,
        child: Text('Login'),
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFF1F1F1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 16.0,
        )),
        shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
        color: Colors.black,
        width: 1.0,),),),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              _entryField(
                  'Email', _emailController
              ),
              const SizedBox(height: 20),
              // Password Text Field
            _entryField(
                'Password', _passwordController
              ),
              const SizedBox(height: 10),
              // Register Text
              RichText(
                text: TextSpan(
                  text: 'No account? ',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Click here to register',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                        fontSize: 12.0,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              _errorMessage(),
              const SizedBox(height: 40),
              // Login Button
              _submitButton()
            ],
          ),
        ),
      ),
    );
  }
}

