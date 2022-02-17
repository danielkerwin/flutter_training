import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/tabs.dart';
import '../widgets/main_drawer.dart';
import './favourites_screen.dart';
import './category_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/';
  final List<Meal> availableMeals;
  final List<Meal> favoriteMeals;

  const TabsScreen({
    Key? key,
    required this.availableMeals,
    required this.favoriteMeals,
  }) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<TabItem> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      TabItem(
        screen: CategoryScreen(availableMeals: widget.availableMeals),
        title: 'Categories',
      ),
      TabItem(
        screen: FavoritesScreen(favoriteMeals: widget.favoriteMeals),
        title: 'Favorites',
      )
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex].title),
      ),
      body: _pages[_selectedPageIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
