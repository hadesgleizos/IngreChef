import 'package:cloud_firestore/cloud_firestore.dart';
import 'fetch_data.dart';

const String USERS_COLLECTION_REF = "users";
const String SAVED_RECIPES_FIELD = "savedRecipes";
const String LOGS_COLLECTION_REF = "logs";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _recipesRef;
  late final CollectionReference _usersRef;
  late final CollectionReference _logsRef;
  final CollectionReference _studentsRef =
  FirebaseFirestore.instance.collection('Students');

  DatabaseService() {
    _recipesRef = _firestore.collection("Recipes");
    _usersRef = _firestore.collection(USERS_COLLECTION_REF);
    _logsRef = _firestore.collection('scans');
  }

  Stream<List<Recipes>> getRecipes() {
    return _recipesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipes.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> saveStudentDetails(String userId, String firstName,
      String lastName, String studentId) async {
    try {
      await _studentsRef.doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'studentId': studentId,
        // Add additional fields as needed
      });
      print('Student details saved successfully for $userId');
    } catch (e) {
      print('Error saving student details: $e');
      throw e;
    }
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

  Future<List<String>> getSavedRecipeIds(String userId) async {
    try {
      DocumentReference userDocRef = _usersRef.doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        List<String> savedRecipes =
        List<String>.from(userDocSnapshot.get(SAVED_RECIPES_FIELD) ?? []);
        print('Fetched saved recipes for user $userId: $savedRecipes');
        return savedRecipes;
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting saved recipes: $e');
      throw e;
    }
  }

  Future<List<Recipes>> getRecipesByIds(List<String> recipeIds) async {
    try {
      List<Future<Recipes?>> futures = recipeIds.map((recipeId) async {
        QuerySnapshot querySnapshot = await _recipesRef
            .where('recipeId', isEqualTo: recipeId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;
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

  Future<void> logScanData(String firstName, String lastName, String studentId,
      List<String> ingredients) async {
    try {
      await _logsRef.add({
        'firstName': firstName,
        'lastName': lastName,
        'studentId': studentId,
        'timestamp': Timestamp.now(),
        'ingredients': ingredients,
      });
      print('Scan logged successfully.');
    } catch (e) {
      print('Error logging scan: $e');
    }
  }
}

