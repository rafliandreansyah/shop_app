import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/products.dart';

import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static final String routeName = '/user-product-screen';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                productData.items[i].title,
                productData.items[i].imgUrl,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
