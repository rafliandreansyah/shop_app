import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  String imgUrl;
  String title;
  double price;

  ProductItem(this.imgUrl, this.title, this.price);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imgUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
          ),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
      ),
    );
  }
}
