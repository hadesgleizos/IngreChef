import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final CollectionReference savedRecipes = FirebaseFirestore.instance.collection('SavedRecipe');

  Future updateUserData(String name, String savedRecipe) async {}

}
