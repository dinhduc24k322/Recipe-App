import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavorieProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites => _favoriteIds;

  FavorieProvider() {
    loadFavorites();
  }
  // toggle favorites states
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  // check if a product is favorited
  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  //add favorites to firestore
  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection("useFavorite").doc(productId).set({
        'isFavorite':
            true, //create the useFavorite collection and add add item as favorites inf firestore
      });
    } catch (e) {
      print(e.toString());
    }
  }
  // remove favorites from firestore

  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection("useFavorite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //load favorites from firestore (store favorites or not)
  Future<void> loadFavorites() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection("userFavorite").get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
  //Static method to access the provider from any context 
  static FavorieProvider of(BuildContext context, {bool listen = true}){
    return Provider.of<FavorieProvider>(
      context,
      listen: listen,
    );
  }
}
