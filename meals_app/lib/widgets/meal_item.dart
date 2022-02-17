import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_screen.dart';

class MealItem extends StatelessWidget {
  final Meal meal;

  const MealItem({
    Key? key,
    required this.meal,
  }) : super(key: key);

  String get complexityText {
    switch (meal.complexity) {
      case MealComplexity.simple:
        return 'simple';
      case MealComplexity.hard:
        return 'hard';
      case MealComplexity.challenging:
        return 'challenging';
      default:
        return 'unknown';
    }
  }

  String get affordibilityText {
    switch (meal.affordability) {
      case MealAffordibility.affordable:
        return 'affordable';
      case MealAffordibility.pricey:
        return 'pricey';
      case MealAffordibility.luxurious:
        return 'luxurious';
      default:
        return 'unknown';
    }
  }

  void selectMeal(BuildContext context) async {
    final mealId = await Navigator.of(context)
        .pushNamed(MealDetailScreen.routeName, arguments: meal);
    if (mealId == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    const roundedBorderValue = 25.0;
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedBorderValue),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(roundedBorderValue),
                    topRight: Radius.circular(roundedBorderValue),
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54.withOpacity(0.0),
                          Colors.black54,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      meal.title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.end,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('${meal.duration} mins'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(complexityText),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(affordibilityText),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
