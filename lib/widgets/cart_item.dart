import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';

class CartItemView extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItemView({this.id, this.title, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      onDismissed: (direction) {
        cart.remove(id);
      },
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Are You Sure'),
                content: Text('Do you want to  remove this item from cart '),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Yes')),
                ],
              )),
      background: Container(
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text('$title'),
            subtitle: Text('total \$${(price * quantity)}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('$quantity X'), Icon(Icons.delete_sweep)],
            ),
          ),
        ),
      ),
    );
  }
}
