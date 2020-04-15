import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem({this.id, this.title, this.quantity, this.price});
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      //Change Quantity
      _items.update(
          id,
          (oldItem) => CartItem(
              id: oldItem.id,
              title: oldItem.title,
              price: oldItem.price,
              quantity: oldItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID].quantity > 1) {
      _items.update(
          productID,
          (oldItem) => CartItem(
              id: oldItem.id,
              price: oldItem.price,
              title: oldItem.title,
              quantity: oldItem.quantity - 1));
    } else
      _items.remove(productID);
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
