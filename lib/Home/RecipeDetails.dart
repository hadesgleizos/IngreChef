import 'package:flutter/material.dart';
import 'package:main/fetchTest.dart';
import 'package:main/Database_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipes recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  Future<void> _saveRecipe(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await DatabaseService().saveRecipeId(userId, recipe.recipeId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to save recipes.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 16),
              Text(
                recipe.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(recipe.description),
              SizedBox(height: 16),
              Text(
                'Ingredients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              for (var ingredient in recipe.ingredients) Text('- $ingredient'),
              SizedBox(height: 16),
              Text(
                'Instructions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('''${recipe.instructions}'''),
              SizedBox(height: 16),
              Text(
                'Preparation Time: ${recipe.prepTime} minutes',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Cooking Time: ${recipe.cookTime} minutes',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Total Time: ${recipe.totalTime} minutes',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _saveRecipe(context),
                child: Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
