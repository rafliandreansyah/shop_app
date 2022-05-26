import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
    //       (_) => setState(() {
    //         _isLoading = false;
    //       }),
    //     );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('an error accurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (c, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.items.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.items[i]),
                  );
                },
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
