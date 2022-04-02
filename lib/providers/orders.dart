import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final DateTime id;
  final double price;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.price, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> products, double price) {
    _items.insert(
        0, OrderItem(DateTime.now(), price, products, DateTime.now()));
    notifyListeners();
  }
}
