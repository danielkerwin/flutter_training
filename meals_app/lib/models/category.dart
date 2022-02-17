import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;

  const Category({
    required this.id,
    required this.title,
    this.color = Colors.orange,
  });
}

class CategoryMealsArgs {
  final String id;
  final String title;

  const CategoryMealsArgs({
    required this.id,
    required this.title,
  });
}
