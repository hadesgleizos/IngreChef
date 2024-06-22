import 'package:cloud_firestore/cloud_firestore.dart';
import 'fetchTest.dart';

const String USERS_COLLECTION_REF = "users";
const String SAVED_RECIPES_FIELD = "savedRecipes";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _recipesRef;
  late final CollectionReference _usersRef;

  DatabaseService() {
    _recipesRef = _firestore.collection("Recipes");
    _usersRef = _firestore.collection(USERS_COLLECTION_REF);
  }

  Stream<List<Recipes>> getRecipes() {
    return _recipesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipes.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> saveRecipeId(String userId, String recipeId) async {
    try {
      DocumentReference userDocRef = _usersRef.doc(userId);
      await userDocRef.set({
        SAVED_RECIPES_FIELD: FieldValue.arrayUnion([recipeId]),
      }, SetOptions(merge: true));
      print('Recipe ID $recipeId saved for user $userId');
    } catch (e) {
      print('Error saving recipe ID: $e');
    }
  }

  Stream<List<String>> getSavedRecipeIds(String userId) {
    try {
      DocumentReference userDocRef = _usersRef.doc(userId);
      return userDocRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          List<String> savedRecipes =
          List<String>.from(snapshot.get(SAVED_RECIPES_FIELD) ?? []);
          print('Fetched saved recipes for user $userId: $savedRecipes');
          return savedRecipes;
        } else {
          return [];
        }
      });
    } catch (e) {
      print('Error getting saved recipes: $e');
      throw e;
    }
  }

  Future<List<Recipes>> getRecipesByIds(List<String> recipeIds) async {
    try {
      List<Future<Recipes?>> futures = recipeIds.map((recipeId) async {
        DocumentSnapshot doc = await _recipesRef.doc(recipeId).get();
        if (doc.exists) {
          return Recipes.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          print('No recipe found with ID $recipeId');
          return null;
        }
      }).toList();

      List<Recipes?> recipes = await Future.wait(futures);
      return recipes.where((recipe) => recipe != null).cast<Recipes>().toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      throw e;
    }
  }
}
