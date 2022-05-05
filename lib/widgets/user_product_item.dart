import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                },
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
              ),
            ],
          )),
    );
  }
}
