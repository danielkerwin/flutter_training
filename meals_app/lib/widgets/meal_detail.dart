import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealDetail extends StatelessWidget {
  final Meal meal;
  const MealDetail({Key? key, required this.meal}) : super(key: key);

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.network(
            meal.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        buildSectionTitle(context, 'Ingredients'),
        buildContainer(
          ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    meal.ingredients[index],
                  ),
                ),
              );
            },
            itemCount: meal.ingredients.length,
          ),
        ),
        buildSectionTitle(context, 'Steps'),
        buildContainer(
          ListView.builder(
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('#${index + 1}'),
                    ),
                    title: Text(
                      meal.steps[index],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Divider(),
                ],
              );
            },
            itemCount: meal.steps.length,
          ),
        )
      ],
    );
  }
}
