import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../widgets/products_list.dart';
import '../providers/products.dart';

enum ItemEmum { OnlyFavorite, ShowAll }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Overview'),
        actions: [
          PopupMenuButton(
            onSelected: (onSelected) {
              setState(() {
                if (onSelected == ItemEmum.OnlyFavorite) {
                  _isFavorite = true;
                } else {
                  _isFavorite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  child: Text('Only Show Favorite'),
                  value: ItemEmum.OnlyFavorite),
              const PopupMenuItem(
                  child: Text('Show All'), value: ItemEmum.ShowAll),
            ],
          ),
        ],
      ),
      body: ProductList(_isFavorite),
    );
  }
}
