import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../models/product.dart';
import '../widgets/products_list.dart';

class ProductOverviewScreen extends StatelessWidget {
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Overview'),
      ),
      body: ProductList(),
    );
  }
}
