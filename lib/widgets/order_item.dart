import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/order_provider.dart';

class OrderItemView extends StatefulWidget {
  final OrderItem orderItem;

  OrderItemView(this.orderItem);

  @override
  _OrderItemViewState createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  bool _expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                setState(() {
                  _expand = !_expand;
                });
              },
              title: Text('\$${widget.orderItem.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy  hh:mm').format(widget.orderItem.time),
              ),
              trailing: Icon(_expand ? Icons.expand_less : Icons.expand_more),
            ),
            _expand
                ? Container(
                    height:
                        min(widget.orderItem.products.length * 20.0 + 10, 100),
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      children: widget.orderItem.products
                          .map((prod) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(prod.title),
                                  Text('${prod.quantity}x \$${prod.price}')
                                ],
                              ))
                          .toList(),
                    ),
                  )
                : Container(
                    child: Text('press to show your order'),
                  )
          ],
        ),
      ),
    );
  }
}
