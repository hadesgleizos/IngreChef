import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/fetchTest.dart';

const String RECIPES_COLLECTION_REF = "Recipes";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _recipesRef;

  DatabaseService() {
    _recipesRef = _firestore.collection(RECIPES_COLLECTION_REF).withConverter<Recipes>(
        fromFirestore: (snapshots, _) => Recipes.fromJson(
          snapshots.data()!,
        ),
        toFirestore: (Recipes, _)=> Recipes.toJson());
  }

  Stream<QuerySnapshot> getRecipes(){
    return _recipesRef.snapshots();
  }

  void addRecipes(Recipes recipes) async {
    _recipesRef.add(recipes);
  }

}