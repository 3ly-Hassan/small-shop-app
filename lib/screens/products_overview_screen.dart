import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/product_data.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';

enum filterOptions { fav, all }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
//  bool _isLoading = false;
//  bool _isiInit = true;
  bool _showFav = false;
  @override
//  void initState() {
//    getDataFromInternet();
//    //
//    super.initState();
//  }

  @override
//  void didChangeDependencies() {
//    if (_isiInit) {
//      setState(() {
//        _isLoading = true;
//      });
//      Provider.of<ProductsData>(context, listen: false).fetchData().then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//      });
//    }
//
//    _isiInit = false;
//    super.didChangeDependencies();
//  }

//  void getDataFromInternet() async {
//    setState(() {
//      _isLoading = true;
//    });
//    try {
//      await Provider.of<ProductsData>(context, listen: false).fetchData();
//      setState(() {
//        _isLoading = false;
//      });
//    } catch (error) {
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text('check your Internet')));
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    final products = Provider.of<ProductsData>(context);
//    final product = _showFav ? products.favItems : products.items;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (filterOptions value) {
                  setState(() {
                    if (value == filterOptions.all)
                      _showFav = false;
                    else
                      _showFav = true;
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Show Favourite'),
                        value: filterOptions.fav,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: filterOptions.all,
                      ),
                    ],
                icon: Icon(
                  Icons.filter_list,
                )),
            Consumer<Cart>(
              builder: (_, cart, ch) {
                return Badge(child: ch, value: cart.itemCount.toString());
              },
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CartScreen();
                    }));
                  }),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<ProductsData>(context, listen: false).fetchData(),
            builder: (ctx, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (data.error != null) {
                  return Center(
                    child: Text('error has occured'),
                  );
                } else
                  return Consumer<ProductsData>(
                    builder: (ctx, products, ch) => GridView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: _showFav
                            ? products.favItems.length
                            : products.items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 3 / 2,
                        ),
                        // الحقيقة انا مش عارف ليه ده
                        itemBuilder: (context, i) =>
                            ChangeNotifierProvider.value(
                              value: _showFav
                                  ? products.favItems[i]
                                  : products.items[i],
                              child: ProductItem(),
                            )),
                  );
              }
            }));
  }
}
