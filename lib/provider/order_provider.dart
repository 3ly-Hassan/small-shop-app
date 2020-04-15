import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app/provider/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem({this.id, this.amount, this.products, this.time});
}

class Order extends ChangeNotifier {
  final String authToken;
  final String userId;
  Order({this.authToken, this.userId});
  List<OrderItem> _order = [];
  List<OrderItem> get order => _order;
  Future<void> addOrder(List<CartItem> cartItem, double amount) async {
    final url =
        'https://shop-7f638.firebaseio.com/order/$userId.json?auth=$authToken';
    final response = await post(url,
        body: json.encode({
          'time': DateTime.now().toIso8601String(),
          'amount': amount,
          'products': cartItem
              .map((cart) => {
                    'id': cart.id,
                    'price': cart.price,
                    'title': cart.title,
                    'quantity': cart.quantity,
                  })
              .toList()
        }));
    _order.insert(
        0,
        OrderItem(
            products: cartItem,
            amount: amount,
            id: json.decode(response.body)['name'],
            time: DateTime.now()));
    notifyListeners();
  }

  Future<void> fetchData() async {
    final url =
        'https://shop-7f638.firebaseio.com/order/$userId.json?auth=$authToken';
    try {
      final response = await get(url);
      final extraData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> dataFromInternet = [];
      if (extraData == null) {
        return;
      }

      extraData.forEach((id, data) {
        dataFromInternet.add(OrderItem(
            id: id,
            amount: data['amount'],
            time: DateTime.parse(data['time']),
            products: (data['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity']))
                .toList()));
      });
      _order = dataFromInternet.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
