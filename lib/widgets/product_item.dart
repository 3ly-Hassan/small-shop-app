import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/products-model.dart';
import 'package:shop_app/screens/details_screen.dart';

class ProductItem extends StatelessWidget {
//  final String title;
//  final String imageUrl;
//  final String description;
//
//  ProductItem({this.title, this.imageUrl, this.description});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(
                  title: product.title,
                  description: product.description,
                  price: product.price,
                  imageUrl: product.imageUrl,
                );
              }));
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: ClipRRect(
            child: GridTileBar(
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Scaffold.of(context).hideCurrentSnackBar();
                  cart.addItem(product.id, product.title, product.price);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Added to the cart'),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                },
                color: Theme.of(context).accentColor,
              ),
              leading: IconButton(
                icon: Icon(
                  product.favourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  product.isFavourite(auth.token, auth.userId);
                },
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black87,
            ),
          )),
    );
  }
}
