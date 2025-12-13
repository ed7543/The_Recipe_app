import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoritesService extends ChangeNotifier {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> _favoriteMealIds = {};

  bool isLoading = true;

  FavoritesService({required this.userId}) {
    _loadFavorites();
  }

  List<String> get favoriteMeals => _favoriteMealIds.toList();

  bool isFavorite(String mealId) {
    return _favoriteMealIds.contains(mealId);
  }

  // Future<void> toggleFavorite(String mealId) async {
  //   // Ensure Firebase is initialized
  //   if (Firebase.apps.isEmpty) return;
  //
  //   final firestore = FirebaseFirestore.instance;
  //
  //   if (_favoriteMealIds.contains(mealId)) {
  //     _favoriteMealIds.remove(mealId);
  //     await firestore
  //         .collection('users')
  //         .doc(userId)
  //         .collection('favorites')
  //         .doc(mealId)
  //         .delete();
  //   } else {
  //     _favoriteMealIds.add(mealId);
  //     await firestore
  //         .collection('users')
  //         .doc(userId)
  //         .collection('favorites')
  //         .doc(mealId)
  //         .set({'addedAt': Timestamp.now()});
  //   }
  //
  //   notifyListeners();
  // }

  Future<void> toggleFavorite(String mealId) async {
    final isFav = _favoriteMealIds.contains(mealId);

    // 1. Update local state immediately for instant UI reaction
    if (isFav) {
      _favoriteMealIds.remove(mealId);
    } else {
      _favoriteMealIds.add(mealId);
    }
    notifyListeners(); // rebuild widgets instantly

    // 2. Update Firestore in the background
    try {
      if (isFav) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(mealId)
            .delete();
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(mealId)
            .set({'addedAt': Timestamp.now()});
      }
    } catch (e) {
      // Optional rollback if Firestore fails
      if (isFav) {
        _favoriteMealIds.add(mealId);
      } else {
        _favoriteMealIds.remove(mealId);
      }
      notifyListeners();
    }
  }


  Future<void> _loadFavorites() async {
    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) return;

    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    _favoriteMealIds.clear();
    for (var doc in snapshot.docs) {
      _favoriteMealIds.add(doc.id);
    }
    notifyListeners();
  }
}
