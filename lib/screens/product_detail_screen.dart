import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)!.settings.arguments as String; // product id

    final product =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.network(
              product.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '\$${product.price}',
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            alignment: Alignment.center,
            child: Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
