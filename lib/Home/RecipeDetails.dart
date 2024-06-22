import 'package:flutter/material.dart';
import 'package:main/fetchTest.dart';
import 'package:main/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipes recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid; // Get the current user's UID

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(recipe.imageUrl),
              const SizedBox(height: 16),
              Text(
                recipe.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(recipe.description),
              const SizedBox(height: 16),
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              for (var ingredient in recipe.ingredients)
                Text('- $ingredient'),
              const SizedBox(height: 16),
              const Text(
                'Instructions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(recipe.instructions),
              const SizedBox(height: 16),
              Text(
                'Preparation Time: ${recipe.prepTime} minutes',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Cooking Time: ${recipe.cookTime} minutes',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Total Time: ${recipe.totalTime} minutes',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Save the recipe ID to the user's document
                  DatabaseService().saveRecipeId(userId, recipe.recipeId);

                  // Optionally show a snackbar or navigate to a confirmation screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recipe saved successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
