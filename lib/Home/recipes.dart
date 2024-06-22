import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Database_Service.dart';
import 'package:main/fetchTest.dart';
import 'package:main/Home/RecipeDetails.dart';

class SavedRecipesPage extends StatefulWidget {
  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  late Future<List<Recipes>> _savedRecipesFuture;

  @override
  void initState() {
    super.initState();
    _savedRecipesFuture = _fetchSavedRecipes();
  }

  Future<List<Recipes>> _fetchSavedRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        Stream<List<String>> savedRecipeIds = DatabaseService().getSavedRecipeIds(user.uid);
        List<Recipes> savedRecipes = await DatabaseService().getRecipesByIds(savedRecipeIds);
        print('Fetched saved recipes: $savedRecipes');
        return savedRecipes;
      } catch (e) {
        print('Error fetching saved recipes: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: FutureBuilder<List<Recipes>>(
        future: _savedRecipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved recipes found.'));
          }

          List<Recipes> savedRecipes = snapshot.data!;
          return ListView.builder(
            itemCount: savedRecipes.length,
            itemBuilder: (context, index) {
              Recipes recipe = savedRecipes[index];
              return Card(
                child: ListTile(
                  title: Text(recipe.name),
                  subtitle: Text(recipe.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
