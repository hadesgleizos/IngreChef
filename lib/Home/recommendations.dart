import 'dart:math';

import 'package:flutter/material.dart';
import 'package:main/Database_Service.dart'; // Import the DatabaseService
import 'package:main/fetchTest.dart'; // Import the Recipes class
import 'package:main/Home/RecipeDetails.dart'; // Import the RecipeDetailPage

class RecommendationPage extends StatefulWidget {
  final List<String> scannedIngredients;

  const RecommendationPage({Key? key, required this.scannedIngredients})
      : super(key: key);

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List<Recipes> _recipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommendations"),
      ),
      body: StreamBuilder<List<Recipes>>(
        stream: DatabaseService().getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No recipes found."));
          }

          _recipes = snapshot.data!;

          var recommendationList = _recommendations(widget.scannedIngredients);

          if (recommendationList.isEmpty) {
            return Center(
                child: Text("No recipes match the scanned ingredients."));

          }

          return ListView.builder(
            itemCount: recommendationList.length,
            itemBuilder: (context, index) {
              var recipe = recommendationList[index];
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

  List<Recipes> _recommendations(List<String> scannedIngredients) {
    List<Recipes> recommendedRecipes = [];

    for (var recipe in _recipes) {
      var similarity = calculateCosineSimilarity(
          scannedIngredients, recipe.scannables);

      // Adjust the similarity threshold as needed (0.5 is just an example)
      if (similarity > 0.5) {
        recommendedRecipes.add(recipe);
      }

      // Debugging logs
      print('Recipe: ${recipe.name}');
      print('Scannables: ${recipe.scannables}');
      print('Similarity with scanned ingredients: $similarity');
    }

    // Sort recommended recipes by descending similarity score
    recommendedRecipes.sort((a, b) =>
        calculateCosineSimilarity(scannedIngredients, b.scannables)
            .compareTo(calculateCosineSimilarity(scannedIngredients, a.scannables)));

    // Debugging log for sorted list
    print('Sorted Recommendation List:');
    recommendedRecipes.forEach((recipe) {
      print('${recipe.name} - Similarity: ${calculateCosineSimilarity(scannedIngredients, recipe.scannables)}');
    });

    return recommendedRecipes;
  }

  double calculateCosineSimilarity(List<String> list1, List<String> list2) {
    var set1 = list1.toSet();
    var set2 = list2.toSet();

    var dotProduct = set1.intersection(set2).length;

    var magnitude1 = sqrt(set1.length.toDouble());
    var magnitude2 = sqrt(set2.length.toDouble());

    var cosineSimilarity = dotProduct / (magnitude1 * magnitude2);

    return cosineSimilarity;
  }
}
