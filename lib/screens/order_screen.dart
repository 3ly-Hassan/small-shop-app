import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  // var _isLoad = false;
  @override
  //void initState() {
//    Future.delayed(Duration.zero).then((_) async {
//      setState(() {
//        _isLoad = true;
//      });
//      await Provider.of<Order>(context, listen: false).fetchData();
//      setState(() {
//        _isLoad = false;
//      });
//    });

  // super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchData(),
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (data.error != null) {
                return Center(
                  child: Text('Error has occured'),
                );
              } else
                return Consumer<Order>(
                    builder: (ctx, orderData, child) => orderData.order.isEmpty
                        ? Center(
                            child: Text('No Order Yet'),
                          )
                        : ListView.builder(
                            itemCount: orderData.order.length,
                            itemBuilder: (ctx, i) =>
                                OrderItemView(orderData.order[i]),
                          ));
            }
          }),
    );
  }
}
