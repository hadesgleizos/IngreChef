import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/Auth/Auth.dart';
import 'package:main/Auth/Widget_Tree.dart';
import 'package:main/Auth/Login.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pop(context);
  } catch (e) {
    // Handle error
    print('nyork');
  }
}

class _VerificationState extends State<Verification> {
  final _auth = Auth();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerificationLink();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const testWidgetTree(),
          ),
        );
      }
    });
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget _resendButton() {
    return ElevatedButton(
      onPressed: () => _auth.sendEmailVerificationLink(),
      child: const Text(
        'Resend Email',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'NanumGothic',
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

  Widget _backToLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(), // Your login screen
          ),
        );
      },
      child: const Text(
        'Back to Login',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'NanumGothic',
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
        title: const Text('Verify your email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'We have sent you an email',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _resendButton(),
            const SizedBox(height: 20),
            _backToLoginButton(),
          ],
        ),
      ),
    );
  }
}