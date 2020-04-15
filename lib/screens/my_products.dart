import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_data.dart';
import 'package:shop_app/screens/edit_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/my_products_item.dart';

class MyProducts extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductsData>(context, listen: false).fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<ProductsData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditScreen()));
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, data) => data.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: Consumer<ProductsData>(
                  builder: (ctx, products, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: products.items.length,
                      itemBuilder: (context, i) => Column(children: <Widget>[
                        MyProductsItem(
                          id: products.items[i].id,
                          title: products.items[i].title,
                          imageUrl: products.items[i].imageUrl,
                        ),
                        Divider()
                      ]),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
