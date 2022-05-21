import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imgUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token) async {
    final oldStateFavorite = isFavorite;
    final url = Uri.parse(
        'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token');
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );

      if (response.statusCode >= 400) {
        isFavorite = oldStateFavorite;
        notifyListeners();
        throw HttpException('error change favorite');
      }
    } catch (onError) {
      isFavorite = oldStateFavorite;
      notifyListeners();
      throw HttpException('error change favorite');
    }
  }
}
