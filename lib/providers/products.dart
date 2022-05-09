import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imgUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    try {
      final response = await http.get(url);
      final convertMap = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      convertMap.forEach((prodId, value) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imgUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (onError) {
      throw onError;
    }
  }

  Future<void> setProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imgUrl,
          'isFavorite': product.isFavorite,
        }),
      );

      print(json.decode(response.body));
      var newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imgUrl: product.imgUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (onError) {
      print(onError);
      throw onError;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> editProduct(String id, Product product) async {
    var index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');

      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imgUrl
          }));

      _items[index] = product;
    } else {
      print('index not found');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final indexProduct = _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[indexProduct];
    final url = Uri.parse(
        'https://flutter-shopapp-2f3cb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    _items.removeAt(indexProduct);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(indexProduct, existingProduct);
      notifyListeners();
      throw HttpException('error delete product');
    }
    existingProduct = null;
  }
}
