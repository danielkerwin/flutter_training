import 'package:flutter/material.dart';
import './tabs_screen.dart';
import '../models/filters.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Filters currentFilters;
  final Function(Filters) applyFilters;

  const FiltersScreen({
    Key? key,
    required this.currentFilters,
    required this.applyFilters,
  }) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;

  @override
  initState() {
    super.initState();
    _glutenFree = widget.currentFilters.gluten;
    _vegetarian = widget.currentFilters.vegetarian;
    _vegan = widget.currentFilters.vegan;
    _lactoseFree = widget.currentFilters.lactose;
  }

  Widget _buildSwitchListTile(
    String title,
    String subtitle,
    bool currentValue,
    Function(bool) updateValue,
  ) {
    return SwitchListTile.adaptive(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.applyFilters(
                Filters(
                  gluten: _glutenFree,
                  lactose: _lactoseFree,
                  vegetarian: _vegetarian,
                  vegan: _vegan,
                ),
              );
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            },
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text('Adjust your meal selection'),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchListTile(
                  'Gluten-free',
                  'Only include gluten-free meals',
                  _glutenFree,
                  (bool val) => setState(() => _glutenFree = val),
                ),
                _buildSwitchListTile(
                  'Lactose-free',
                  'Only include lactose-free meals',
                  _lactoseFree,
                  (bool val) => setState(() => _lactoseFree = val),
                ),
                _buildSwitchListTile(
                  'Vegetarian',
                  'Only include vegetarian meals',
                  _vegetarian,
                  (bool val) => setState(() => _vegetarian = val),
                ),
                _buildSwitchListTile(
                  'Vegan',
                  'Only include vegan meals',
                  _vegan,
                  (bool val) => setState(() => _vegan = val),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
