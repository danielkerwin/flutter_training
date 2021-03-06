import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/http_exception.model.dart';

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

  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    final current = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(
      Api.database,
      '/userFavorites/$userId/$id.json',
      {'auth': authToken},
    );

    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
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
