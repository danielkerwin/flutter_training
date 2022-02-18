import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/http_exception.model.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final current = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse('$databaseUrl/products/$id.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'title': title,
          'description': description,
          'price': price,
          'imageUrl': imageUrl,
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Failed to update favorite');
      }
    } catch (err) {
      isFavorite = current;
      notifyListeners();
      print(err.toString());
      throw HttpException(err.toString());
    }
  }
}
