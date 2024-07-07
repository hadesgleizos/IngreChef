import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1), // Set the background color of the entire screen
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
        title: Text('About', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black), // Change back button color to black
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About the App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ingre-Chef is a mobile application designed to assist culinary students by providing real-time ingredient detection and recipe recommendations. The app accurately identifies ingredients through your devices camera and suggests recipes based on the available ingredients. With secure user registration, personalized recipe collections, and comprehensive help resources, Ingre-Chef enhances the culinary learning experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We are college students who developed this project for our software engineering course.\n\n'
                  'Charles Vincent A Fernando\n'
                  'Orland II P. Geronimo\n'
                  'Pocholo A. Granada',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'For inquiries, please refer to the provided email address and contact numbers.\n\n'
                  'qcvafernando@tip.edu.manzano         +639150580952\n'
                  'qogeronimo@tip.edu.ph                +639465436163\n'
                  'qpagranada@tip.edu.ph                +639958560758',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
