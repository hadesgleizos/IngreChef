import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/database_service.dart';
import 'package:main/fetchTest.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage>{
  final DatabaseService _databaseService = DatabaseService();

  Widget _build(){
    return SafeArea(
        child: Column(
          children: [
            _messagesListView(),
          ],
        )
    );
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child:StreamBuilder(
        stream: _databaseService.getRecipes(),
        builder: (context, snapshot) {
          List recipes = snapshot.data?.docs??[];
          if (recipes.isEmpty){
            return const Center(
              child: Text("No Recipes Found"),
            );
          }
          print(recipes);
          return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index){
                Recipes recipe = recipes[index].data();
                String recipesId = recipes[index].id;
            return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                title: Text(recipe.name),
                subtitle: Text(recipe.description),
              ),
            );
          });
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommendations"),
      ),
      body: _build(),
      );
  }
}
