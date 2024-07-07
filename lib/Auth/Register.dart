import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Auth/Auth.dart';
import 'package:main/database_service.dart';
import 'package:main/Auth/Verification.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Initially password is obscured

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create user with email and password
        UserCredential userCredential = await Auth().createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Get the UID of the registered user
        String uid = userCredential.user!.uid;

        // Save user details to Firestore using DatabaseService
        await DatabaseService().saveStudentDetails(
          uid,
          _firstNameController.text,
          _lastNameController.text,
          _studentIdController.text,
        );

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Verification()),
        );
        }
        catch(e){
        print(errorMessage);
      }
    }
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ) {
    return TextFormField(
      controller: controller,
      obscureText: title == 'Password' ? _obscureText : false,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
        suffixIcon: title == 'Password'
            ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: _togglePasswordVisibility,
        )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $title';
        }
        return null;
      },
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : '$errorMessage',
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () => createUserWithEmailAndPassword(context),

      child: const Text(
        'Register',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'NanumGothic',
          fontSize: 18,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFF1F1F1)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide.none,
          ),
        ),
        elevation: MaterialStateProperty.all(2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'IngreChef',
                    style: TextStyle(
                      fontFamily: 'GreatVibes',
                      fontSize: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _entryField('First Name', _firstNameController),
                const SizedBox(height: 10),
                _entryField('Last Name', _lastNameController),
                const SizedBox(height: 10),
                _entryField('Student ID', _studentIdController),
                const SizedBox(height: 20),
                _entryField('Email', _emailController),
                const SizedBox(height: 10),
                _entryField('Password', _passwordController),
                _errorMessage(),
                const SizedBox(height: 20),
                _submitButton(),
                const SizedBox(height: 20), // Additional space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
