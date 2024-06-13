import 'package:main/Auth/auth.dart';
import 'package:main/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:main/Auth/login_screen.dart';
import 'Verification.dart';

class testWidgetTree extends StatefulWidget {
  const testWidgetTree({Key? key}) : super(key: key);

  @override
  State<testWidgetTree> createState() => _testWidgetTreeState();
}

class _testWidgetTreeState extends State<testWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Login();
        } else {
          if (snapshot.data?.emailVerified == false) {
            //set to false to bypass verification
            return MyHomePage();
          }
          return const Verification();
        }
      },
    );
  }
}
