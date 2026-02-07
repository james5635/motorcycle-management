import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addToCart(Map<String, dynamic> product) {
    // Check if product already in cart
    int index = _items.indexWhere(
      (item) => item['product_id'] == product['product_id'],
    );
    if (index != -1) {
      _items[index]['quantity'] = (_items[index]['quantity'] ?? 1) + 1;
    } else {
      product['quantity'] = 1;
      _items.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _items.removeWhere((item) => item['product_id'] == product['product_id']);
    notifyListeners();
  }

  void updateQuantity(Map<String, dynamic> product, int quantity) {
    int index = _items.indexWhere(
      (item) => item['product_id'] == product['product_id'],
    );
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index]['quantity'] = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount =>
      _items.fold(0, (sum, item) => sum + (item['quantity'] as int));

  double get totalAmount => _items.fold(0, (sum, item) {
    double price = double.tryParse(item['price'].toString()) ?? 0.0;
    int quantity = item['quantity'] as int;
    return sum + (price * quantity);
  });
}
