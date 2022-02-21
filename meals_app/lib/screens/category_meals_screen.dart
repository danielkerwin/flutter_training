import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import '../models/category.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';
  final List<Meal> availableMeals;

  const CategoryMealsScreen({
    Key? key,
    required this.availableMeals,
  }) : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  void removeMeal(String mealId) {}
  List<Meal> displayedMeals = [];
  CategoryMealsArgs? categoryMealsArgs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categoryMealsArgs =
        ModalRoute.of(context)!.settings.arguments as CategoryMealsArgs;

    displayedMeals = widget.availableMeals
        .where((meal) => meal.categoryIds.contains(categoryMealsArgs?.id))
        .toList();
  }

  // void _removeItem(String id) {
  //   setState(() {
  //     displayedMeals.removeWhere((meal) => meal.id == id);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${categoryMealsArgs?.title} Recipes'),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) => MealItem(
              meal: displayedMeals[index],
            )),
        itemCount: displayedMeals.length,
      ),
    );
  }
}
