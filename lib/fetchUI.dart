import 'package:flutter/material.dart';
import 'package:main/database_service.dart';
import 'fetchTest.dart';



class RecipeListScreen extends StatelessWidget {
  final DatabaseService _databaseServiceService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
    );
  }
}
