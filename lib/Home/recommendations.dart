import 'package:flutter/material.dart';

class AnotherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Another Screen"),
      ),
      body: Center(
        child: Text("You have navigated to another screen"),
      ),
    );
  }
}
