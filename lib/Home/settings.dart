import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Auth/auth.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid(){
    return Text(user?.email ?? 'User Email');
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text('Sign out'),);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          children:<Widget>[
            _userUid(),
            _signOutButton(),
          ]
        )
      ),
    );
  }
}
