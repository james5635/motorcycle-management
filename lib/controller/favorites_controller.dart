import 'package:flutter/material.dart';

class FavoritesController extends ChangeNotifier {
  static final FavoritesController _instance = FavoritesController._internal();
  factory FavoritesController() => _instance;
  FavoritesController._internal();

  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addToFavorites(Map<String, dynamic> product) {
    // Check if product already in favorites
    int index = _favorites.indexWhere(
      (item) => item['productId'] == product['productId'],
    );
    if (index == -1) {
      _favorites.add(Map<String, dynamic>.from(product));
      notifyListeners();
    }
  }

  void removeFromFavorites(Map<String, dynamic> product) {
    _favorites.removeWhere((item) => item['productId'] == product['productId']);
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> product) {
    return _favorites.any((item) => item['productId'] == product['productId']);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    if (isFavorite(product)) {
      removeFromFavorites(product);
    } else {
      addToFavorites(product);
    }
  }

  int get favoriteCount => _favorites.length;

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
