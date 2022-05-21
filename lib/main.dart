import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_product_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/order_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(null, []),
            update: (ctx, auth, oldProducts) => Products(
                auth.token, oldProducts == null ? [] : oldProducts.items)),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(
            null,
            [],
          ),
          update: (ctx, auth, previousOrder) => Orders(
              auth.token, previousOrder == null ? [] : previousOrder.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctxx, authData, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.amber,
            fontFamily: 'OpenSans',
          ),
          home: authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
