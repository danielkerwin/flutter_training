import 'package:flutter/material.dart';
import './screens/favourites_screen.dart';
import 'dummy_data.dart';
import './models/filters.dart';
import './models/meal.dart';
import './screens/filters_screen.dart';
import './screens/tabs_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Filters _filters = const Filters();
  List<Meal> _availableMeals = dummyMeals;
  final List<Meal> _favoriteMeals = [];

  void _setFilters(Filters filters) {
    setState(() {
      _filters = filters;
      _availableMeals = dummyMeals.where((meal) {
        if (_filters.gluten && !meal.isGlutenFree) {
          return false;
        }
        if (_filters.lactose && !meal.isLactoseFree) {
          return false;
        }
        if (_filters.vegan && !meal.isVegan) {
          return false;
        }
        if (_filters.vegetarian && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String id) {
    final existingIndex = _favoriteMeals.indexWhere((meal) => meal.id == id);
    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(dummyMeals.firstWhere((meal) => meal.id == id));
      });
    }
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.pink,
      fontFamily: 'Raleway',
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyLarge: const TextStyle(
              fontSize: 24,
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyMedium: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodySmall: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            titleLarge: const TextStyle(
              fontSize: 23,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            ),
            titleMedium: const TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.normal,
            ),
            titleSmall: const TextStyle(
              fontSize: 18,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.normal,
            ),
          ),
    );

    return MaterialApp(
      title: 'DeliMeals',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.yellowAccent,
        ),
      ),
      initialRoute: TabsScreen.routeName,
      routes: {
        TabsScreen.routeName: (ctx) => TabsScreen(
              availableMeals: _availableMeals,
              favoriteMeals: _favoriteMeals,
            ),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(
              availableMeals: _availableMeals,
            ),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(
              isFavorite: _isMealFavorite,
              toggleFavorite: _toggleFavorite,
            ),
        FiltersScreen.routeName: (ctx) => FiltersScreen(
              currentFilters: _filters,
              applyFilters: _setFilters,
            ),
        FavoritesScreen.routeName: (ctx) => FavoritesScreen(
              favoriteMeals: _favoriteMeals,
            ),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (ctx) => CategoryScreen(
          availableMeals: _availableMeals,
        ),
      ),
    );
  }
}
