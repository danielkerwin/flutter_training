import 'package:flutter/material.dart';
import '../widgets/meal_item.dart';
import '../models/meal.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favourites';
  final List<Meal> favoriteMeals;

  const FavoritesScreen({
    Key? key,
    required this.favoriteMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoriteMeals.isEmpty) {
      return const Center(
        child: Text('You have no favorites yet'),
      );
    }
    return ListView.builder(
      itemBuilder: ((context, index) => MealItem(
            meal: favoriteMeals[index],
          )),
      itemCount: favoriteMeals.length,
    );
  }
}
