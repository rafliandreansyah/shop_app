import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get prodCart {
    return _items.length;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    _items.forEach((key, value) {
      totalAmount += value.price * value.quantity;
    });
    return totalAmount;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingProduct) => CartItem(
            id: existingProduct.id,
            title: existingProduct.title,
            price: existingProduct.price,
            quantity: existingProduct.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
