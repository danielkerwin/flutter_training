import 'package:flutter/material.dart';
import 'package:shop_app/mock_data.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = MOCK_PRODUCTS;

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

  void addItem(Product item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
