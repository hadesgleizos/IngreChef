import 'package:flutter/material.dart';
import 'package:main/fetchTest.dart'; // Import your Recipes class
import 'package:main/database_service.dart'; // Import your DatabaseService class
import 'package:firebase_auth/firebase_auth.dart';

import 'RecipeDetails.dart';

class SavedRecipesPage extends StatelessWidget {
  const SavedRecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid; // Get the current user's UID

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: StreamBuilder<List<String>>(
        stream: DatabaseService().getSavedRecipeIds(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved recipes found.'));
          }

          List<String> savedRecipeIds = snapshot.data!;
          print('Saved recipe IDs: $savedRecipeIds');

          return FutureBuilder<List<Recipes>>(
            future: DatabaseService().getRecipesByIds(savedRecipeIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No saved recipes found.'));
              }

              List<Recipes> savedRecipes = snapshot.data!;
              print('Fetched saved recipes: $savedRecipes');

              return ListView.builder(
                itemCount: savedRecipes.length,
                itemBuilder: (context, index) {
                  Recipes recipe = savedRecipes[index];
                  return ListTile(
                    leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(recipe.name),
                    subtitle: Text('Preparation Time: ${recipe.prepTime} minutes'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(recipe: recipe),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
