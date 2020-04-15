import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exption.dart';
import 'package:shop_app/provider/products-model.dart';

class ProductsData extends ChangeNotifier {
  List<Product> _items = [
//    Product(
//        id: 'sh1',
//        imageUrl:
//            'https://cdn1.basket4ballers.com/87725-large_default/pantalon-jordan-sport-dna-cargo-cd5734-010.jpg',
//        title: '',
//        description: 'blue t-shirt',
//        price: 29.23),
//    Product(
//        id: 'sh2',
//        imageUrl:
//            'https://cdn11.bigcommerce.com/s-rxzabllq/images/stencil/1280x1280/products/910/18045/Kids-Plain-Poly-Fit-Quick_Dry-Tshirt-red__13799.1567089094.jpg?c=2',
//        title: 'T-shirt',
//        description: 'blue t-shirt',
//        price: 29.23),
//    Product(
//        id: 'sh3',
//        imageUrl:
//            'https://www.theoutnet.com/variants/images/14097096494529350/F/w920_q80.jpg',
//        title: 'Skirt',
//        description: 'blue t-shirt',
//        price: 29.23),
//    Product(
//        id: 'sh4',
//        imageUrl:
//            'https://images-na.ssl-images-amazon.com/images/I/71bhZPKrmJL._AC_UX522_.jpg',
//        title: 'Scarf',
//        description: 'blue t-shirt',
//        price: 29.23),
  ];
  final String token;
  final String userId;
  ProductsData({
    this.userId,
    this.token,
  });

  List<Product> get items => _items;
  List<Product> get favItems => _items.where((prod) => prod.favourite).toList();
  Product finItemById(String id) => _items.firstWhere((prod) => prod.id == id);
  Future<void> addItem(Product product) async {
    final url = 'https://shop-7f638.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'creatorId': userId
        }),
      );

      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchData([bool filterById = false]) async {
    final String filterString =
        filterById ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-7f638.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      final extraData = json.decode(response.body) as Map<String, dynamic>;
      if (extraData == null) {
        return;
      }
      url =
          'https://shop-7f638.firebaseio.com/favouriteItem/$userId/.json?auth=$token';
      final favResponse = await http.get(url);
      final favDataResponse = json.decode(favResponse.body);
      final List<Product> dataFromInternet = [];
      extraData.forEach((id, data) {
        dataFromInternet.add(Product(
          id: id,
          title: data['title'],
          price: data['price'],
          description: data['description'],
          imageUrl: data['imageUrl'],
          favourite:
              favDataResponse == null ? false : favDataResponse[id] ?? false,
        ));
      });
      _items = dataFromInternet;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateItem(String id, Product newProduct) async {
    final indexOfItem = _items.indexWhere((prod) => prod.id == id);
    if (indexOfItem >= 0) {
      final url =
          'https://shop-7f638.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[indexOfItem] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> removeItem(String id) async {
    final url =
        'https://shop-7f638.firebaseio.com/products/$id.json?auth=$token';
    final index = _items.indexWhere((prod) => prod.id == id);
    var product = _items[index];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException('couldn\'t delet this item');
    }
    product = null;
  }
}
