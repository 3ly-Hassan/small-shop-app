import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_data.dart';
import 'package:shop_app/screens/edit_screen.dart';

class MyProductsItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;

  MyProductsItem({this.imageUrl, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditScreen(id: id)));
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  try {
                    await Provider.of<ProductsData>(context, listen: false)
                        .removeItem(id);
                  } catch (_) {
                    scaffold.showSnackBar(
                        SnackBar(content: Text('couldn\'t delet')));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
