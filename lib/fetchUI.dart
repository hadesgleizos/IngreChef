import 'package:flutter/material.dart';
import 'fetchTest.dart';

class RecipeListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
    );
  }
}
