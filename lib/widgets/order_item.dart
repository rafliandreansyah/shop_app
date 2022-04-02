import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.price}'),
            subtitle: Text(
              DateFormat('dd MMM yyyy HH:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_isExpanded)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.products[i].title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.order.products[i].quantity}x \$${widget.order.products[i].price}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: widget.order.products.length,
              ),
            )
        ],
      ),
    );
  }
}
