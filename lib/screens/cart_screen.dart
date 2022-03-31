import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        label: Text(
                          '\$${cart.totalAmount}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  ?.color),
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                    onPressed: () {},
                    textColor: Theme.of(context).primaryColor,
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                productId: cart.items.keys.toList()[i],
              ),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}
