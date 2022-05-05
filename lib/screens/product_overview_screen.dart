import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/products_list.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum ItemEmum { OnlyFavorite, ShowAll }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isFavorite = false;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetProducts(); tidak berfungsi karena belum mendapatkan context

    // Maka harus menggunakan beberapa cara dibawah ini
    // #1 Provider.of<Products>(context, listen: false).fetchAndSetProducts(); jika memanggil provider pada init state harus dikasih listen false
    // #2 Future.delayed(Duration.zero).then((_) => Provider.of<Products>(context).fetchAndSetProducts());
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => {
              setState(() {
                _isLoading = false;
              })
            });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Atau dapat dipanggil di didChangeDependencies
    // #3 if (_isInit) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
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
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.prodCart.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductList(_isFavorite),
    );
  }
}
