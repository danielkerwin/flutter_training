import 'package:flutter/material.dart';
import 'package:shop_app/providers/carts.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  void addOrder(List<Cart> cartProducts, double total) {
    _items.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
