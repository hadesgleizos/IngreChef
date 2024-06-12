import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/Auth/auth.dart';
import 'package:main/Auth/widget_tree.dart';

class Verification extends StatefulWidget {
  const Verification ({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();

}

class _VerificationState extends State<Verification> {
  final _auth = Auth();
  late Timer timer;
  @override
  void initState(){
    super.initState();
    _auth.sendEmailVerificationLink();
    timer = Timer.periodic(const Duration(seconds: 5), (timer){
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const testWidgetTree(),));
    }
    });
  }



  Widget _resendButton() {
    return ElevatedButton(
      onPressed: () => _auth.sendEmailVerificationLink(),
      child: Text('Resend Email'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFF1F1F1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
          horizontal: 150.0,
          vertical: 18.0,
        )),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide.none, // Remove the border
          ),
        ),
        elevation: MaterialStateProperty.all(2), // Add shadow
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
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _resendButton()],),),);
  }
}
