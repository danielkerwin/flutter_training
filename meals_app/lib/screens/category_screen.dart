import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../dummy_data.dart';
import '../widgets/category_item.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/categories';
  final List<Meal> availableMeals;

  const CategoryScreen({Key? key, required this.availableMeals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(20.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: dummyCategories
          .map(
            (category) => CategoryItem(
              title: category.title,
              color: category.color,
              id: category.id,
            ),
          )
          .where(
            (category) => availableMeals.any(
              (meal) => meal.categoryIds.contains(category.id),
            ),
          )
          .toList(),
    );
  }
}
