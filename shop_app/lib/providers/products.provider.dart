import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/http_exception.model.dart';
import 'package:shop_app/providers/product.provider.dart';

class Products with ChangeNotifier {
  String? _authToken;
  List<Product> _items = [];

  set authToken(String? token) {
    _authToken = token;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product getOneById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  void update() {
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse('${Api.database}/products.json?auth=$_authToken');
    // try {
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      return;
    }
    final data = json.decode(response.body) as Map<String, dynamic>? ?? {};
    _items = data.entries.map((item) {
      return Product(
        id: item.key,
        title: item.value['title'],
        description: item.value['description'],
        imageUrl: item.value['imageUrl'],
        price: item.value['price'],
        isFavorite: item.value['isFavorite'],
      );
    }).toList();
    notifyListeners();
    // } catch (err) {
    //   print(err.toString());
    //   throw Exception(err.toString());
    // }
  }

  Future<void> addOne(Product item) async {
    final url = Uri.parse('${Api.database}/products.json?auth=$_authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'isFavorite': item.isFavorite,
          'price': item.price,
          'imageUrl': item.imageUrl,
        }),
      );
      final responseData = json.decode(response.body);
      _items.add(Product(
        id: responseData['name'],
        description: item.description,
        title: item.title,
        isFavorite: item.isFavorite,
        price: item.price,
        imageUrl: item.imageUrl,
      ));
      _items.add(item);
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  Future<void> updateOne(Product item) async {
    final url =
        Uri.parse('${Api.database}/products/${item.id}.json?auth=$_authToken');
    final index = _items.indexWhere((el) => el.id == item.id);
    try {
      await http.patch(
        url,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'price': item.price,
          'imageUrl': item.imageUrl,
        }),
      );
      _items.removeAt(index);
      _items.insert(index, item);
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw HttpException(err.toString());
    }
  }

  Future<void> removeOne(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    final item = _items[index];
    _items.removeAt(index);
    notifyListeners();

    final url = Uri.parse('${Api.database}/products/$id.json?auth=$_authToken');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Failed to delete product');
      }
    } catch (err) {
      print('ERROR=${err.toString()}');
      _items.insert(index, item);
      notifyListeners();
      throw HttpException(err.toString());
    }
  }
}
