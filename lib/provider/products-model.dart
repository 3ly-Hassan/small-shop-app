import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool favourite;

  Product(
      {this.id,
      this.title,
      this.imageUrl,
      this.description,
      this.price,
      this.favourite = false});
  void isFavourite(String token, String userId) async {
    var oldStatus = this.favourite;
    this.favourite = !this.favourite;
    notifyListeners();
    final url =
        'https://shop-7f638.firebaseio.com/favouriteItem/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url, body: json.encode(this.favourite));
      if (response.statusCode >= 400) {
        this.favourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      this.favourite = oldStatus;
      notifyListeners();
    }
  }
}
