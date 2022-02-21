import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/http_exception.model.dart';
import 'carts.provider.dart';

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
  String? _authToken;
  String? _userId;
  List<Order> _items = [];

  set authToken(String? token) {
    _authToken = token;
  }

  set userId(String? userId) {
    _userId = userId;
  }

  List<Order> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
      Api.database,
      '/orders/$_userId.json',
      {'auth': _authToken},
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        return;
      }
      final data = json.decode(response.body) as Map<String, dynamic>? ?? {};
      _items = data.entries
          .map((item) {
            return Order(
              id: item.key,
              amount: item.value['amount'],
              products: (item.value['products'] as List<dynamic>)
                  .map(
                    (item) => Cart(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(item.value['dateTime']),
            );
          })
          .toList()
          .reversed
          .toList();
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw HttpException(err.toString());
    }
  }

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url = Uri.https(
      Api.database,
      '/orders/$_userId.json',
      {'auth': _authToken},
    );
    final dateTime = DateTime.now();
    try {
      final body = json.encode({
        'amount': total,
        'products': cartProducts
            .map(
              (item) => {
                'id': item.id,
                'title': item.title,
                'quantity': item.quantity,
                'price': item.price,
              },
            )
            .toList(),
        'dateTime': dateTime.toIso8601String(),
      });
      final response = await http.post(url, body: body);
      if (response.statusCode >= 400) {
        throw HttpException('Failed to add order');
      }
      final responseData = json.decode(response.body);
      _items.insert(
        0,
        Order(
          id: responseData['name'],
          amount: total,
          products: cartProducts,
          dateTime: dateTime,
        ),
      );
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw HttpException(err.toString());
    }
  }
}
