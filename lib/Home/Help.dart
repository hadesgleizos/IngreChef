import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1), // background color of the entire screen
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
        title: Text('Help', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black), // Change back button color to black
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FAQ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Q: What is Ingre-Chef?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: Ingre-Chef is a mobile application designed to help culinary students and teachers by providing ingredient detection and recipe recommendations. It uses advanced technology, including TensorFlow Lite for object detection, to identify ingredients through your devices camera and suggest relevant recipes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: How do I register for an account?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: You can register for an account through the Ingre-Chef mobile application if you are a student, or through the website if you are a teacher. You will need to provide your first name, last name, email, and password. Make sure the email you input is accessible because you will need to verify your account through an email verification process.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: How does the ingredient detection work?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: The ingredient detection feature uses your mobile device’s camera to scan and identify ingredients in real-time. The application utilizes TensorFlow Lite for object detection to process the images and provide accurate identification results.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: What is the Recipe Suggestions feature?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: Once ingredients are identified, the Recipe Suggestions feature uses a cosine similarity algorithm to compare the scanned ingredients with ingredients listed in various recipes. It recommends recipes that best match the available ingredients.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: Can I save my favorite recipes?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: Yes, the Saved Recipes module allows you to save your favorite recipes, creating a personalized collection for easy access. You can retrieve these saved recipes whenever you need inspiration or guidance.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: How do I reset my password?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: If you forget your password, you can use the password recovery feature. It will guide you through resetting your password via email verification.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: What information can teachers access on the monitoring website?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: Teachers can use the monitoring website to track student activity. They can view detailed logs of which ingredients are scanned and the timestamp when did they use the app, to monitor student progress and engagement.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: What kind of ingredients can Ingre-Chef detect?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: Ingre-Chef is optimized to detect common ingredients used in cooking. Currently, there are limited ingredients available in the database, and we are continually working to expand the variety.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: Does Ingre-Chef require an internet connection?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: Yes, Ingre-Chef requires a stable internet connection to access the recipe database and provide up-to-date recipe suggestions. Some features may be limited in areas with poor connectivity.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Q: How does the quality of my camera affect ingredient detection?',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'A: The quality of your devices camera can significantly impact the accuracy of ingredient detection. Higher resolution cameras can capture clearer images, allowing the TensorFlow Lite to accurately identify and classify ingredients. Lower resolution or poor-quality cameras may result in blurry images, leading to potential misidentifications or errors in detection.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'User Manual',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Step 1: Click "Scan Now" to scan an ingredient.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Step 2: The app will ask for permission to use the devices camera and microphone. Make sure to click "Allow."',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Step 3: Aim the camera at the ingredient you want to scan. Once it recognizes the ingredient, you may proceed to scan another ingredient.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Step 4: Once satisfied with the scanned ingredients, you can press done. The app will recommend recipes based on the ingredients you scanned, you can select a recipe you want to view its full details.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Step 5: You may save the recommended recipes, and they will automatically be saved in "Saved Recipes" on the main menu page.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
