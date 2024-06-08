import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Auth/auth.dart';


class Register extends StatefulWidget{
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  String? errorMessage = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
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
        labelText: title,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
      createUserWithEmailAndPassword,
      child: Text('Register'),
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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'IngreChef',
                style: TextStyle(
                  fontFamily: 'GreatVibes',
                  fontSize: 60,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _entryField('Email', _emailController),
            const SizedBox(height: 10),
            _entryField('Password', _passwordController),
            _errorMessage(),
            const SizedBox(height: 20),
            _submitButton()
          ],
        ),
      ),
    );
  }
}
