import 'package:flutter/material.dart';

class SavedRecipes extends StatelessWidget {
  const SavedRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyRecipes(title: 'Camera Button App'),
    );
  }
}

class MyRecipes extends StatefulWidget {
  const MyRecipes({super.key, required this.title});

  final String title;

  @override
  State<MyRecipes> createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  void _onCameraButtonPressed() {
    print('Recipe Button Pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _onCameraButtonPressed,
          child: const Icon(
            Icons.no_food,
            size: 50,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.black
          ),
        ),
      ),
    );
  }
}
