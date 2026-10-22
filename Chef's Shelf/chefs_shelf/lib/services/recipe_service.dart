
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _recipes {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('É necessário entrar na conta para salvar receitas.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recipes');
  }

  Future<void> saveRecipe({
    required String id,
    required String name,
    required String imageUrl,
    required String category,
    required String instructions,
  }) async {
    await _recipes.doc(id).set({
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'instructions': instructions,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSavedRecipes() {
    return _recipes
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  Future<void> deleteRecipe(String id) async {
    await _recipes.doc(id).delete();
  }

  Future<bool> isRecipeSaved(String id) async {
    final document = await _recipes.doc(id).get();
    return document.exists;
  }
}
