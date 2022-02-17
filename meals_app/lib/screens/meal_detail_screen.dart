import 'package:flutter/material.dart';
import '../widgets/meal_detail.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatelessWidget {
  static const String routeName = '/meal-detail';
  final Function(String) toggleFavorite;
  final Function(String) isFavorite;

  const MealDetailScreen({
    Key? key,
    required this.toggleFavorite,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(meal.title),
        ),
        actions: [
          IconButton(
            onPressed: () => toggleFavorite(meal.id),
            icon: Icon(
              isFavorite(meal.id)
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: MealDetail(meal: meal),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).errorColor,
        child: const Icon(Icons.delete),
        onPressed: () => Navigator.of(context).pop(meal.id),
      ),
    );
  }
}
