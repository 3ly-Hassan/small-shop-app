import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart' show Cart;
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Your Cart',
      )),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total'),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  ButtonToOrder(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return CartItemView(
                  id: cart.items.keys.toList()[i],
                  price: cart.items.values.toList()[i].price,
                  title: cart.items.values.toList()[i].title,
                  quantity: cart.items.values.toList()[i].quantity,
                );
              },
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class ButtonToOrder extends StatefulWidget {
  const ButtonToOrder({
    @required this.cart,
  });

  final Cart cart;

  @override
  _ButtonToOrderState createState() => _ButtonToOrderState();
}

class _ButtonToOrderState extends State<ButtonToOrder> {
  var _isLoad = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoad = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clear();
              setState(() {
                _isLoad = false;
              });
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => OrderScreen()));
            },
      child: _isLoad ? CircularProgressIndicator() : Text('Order Now'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
