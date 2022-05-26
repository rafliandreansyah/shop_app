import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/order_item.dart';

class OrderItem {
  final String id;
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

  var authToken;
  var userId;

  Orders(this.authToken, this.userId, this._items);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> orders = [];
    final extractOrder = json.decode(response.body) as Map<String, dynamic>;
    if (extractOrder == null) {
      return;
    }
    extractOrder.forEach((orderId, orderItem) {
      orders.add(OrderItem(
        orderId,
        orderItem['amount'],
        (orderItem['products'] as List<dynamic>)
            .map(
              (data) => CartItem(
                id: data['id'],
                title: data['title'],
                price: data['price'],
                quantity: data['quantity'],
              ),
            )
            .toList(),
        DateTime.parse(orderItem['dateTime']),
      ));
    });

    _items = orders.reversed.toList();
    notifyListeners();
    print(json.decode(response.body));
  }

  Future<void> addOrder(List<CartItem> products, double price) async {
    final url = Uri.parse(
        'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': price,
            'dateTime': timeStamp.toIso8601String(),
            'products': products
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity
                    })
                .toList(),
          },
        ),
      );
      _items.insert(
          0,
          OrderItem(
              json.decode(response.body)['name'], price, products, timeStamp));
      notifyListeners();
    } catch (onError) {
      print('Error orders: $onError');
    }
  }
}
