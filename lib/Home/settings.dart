import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Auth/auth.dart';
import 'package:main/Home/about.dart';
import 'package:main/Home/help.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final User? user = Auth().currentUser;

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

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context), // Pass the context to the signOut function
      child: const Text('Sign out'),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Color(0xFFF1F1F1), // background color of the entire screen
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // color of app bar
        elevation: 0, // Remove app bar shadow
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'NanumGothic', // custom font
            // fontWeight: FontWeight.bold, // Make the text bold
            // fontStyle: FontStyle.italic
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 5.0), // Add padding to the ListView
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 3.0), // spacing between tiles
            padding: const EdgeInsets.all(10.0), // modify for larger tiles
            decoration: BoxDecoration(
              color: Colors.white, // Set tile background color to white
              borderRadius: BorderRadius.circular(5.0), // Rounded corners
              //border: Border.all(color: Colors.grey), // Outline color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.help),
              title: Text(
                'Help',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NanumGothic', // custom font
                  // fontWeight: FontWeight.bold, // Make the text bold
                  // fontStyle: FontStyle.italic
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
            ),
          ),
          Container(
            margin:
            const EdgeInsets.only(bottom: 3.0), // Add spacing between tiles
            padding: const EdgeInsets.all(10.0), // modify for larger tiles
            decoration: BoxDecoration(
              color: Colors.white, // Set tile background color to white
              borderRadius: BorderRadius.circular(5.0), // Rounded corners
              //border: Border.all(color: Colors.grey), // Outline color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NanumGothic', // custom font
                  // fontWeight: FontWeight.bold, // Make the text bold
                  // fontStyle: FontStyle.italic
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ),
          Container(
            margin:
            const EdgeInsets.only(bottom: 3.0), // Add spacing between tiles
            padding: const EdgeInsets.all(10.0), // modify for larger tiles
            decoration: BoxDecoration(
              color: Color.fromARGB(
                  255, 255, 255, 255), // Set tile background color to white
              borderRadius: BorderRadius.circular(5.0), // Rounded corners
              //border: Border.all(color: Colors.grey), // Outline color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NanumGothic', // custom font
                  // fontWeight: FontWeight.bold, // Make the text bold
                  // fontStyle: FontStyle.italic
                ),
              ),
              onTap: () {
                // Handle logout action
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      _signOutButton(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
