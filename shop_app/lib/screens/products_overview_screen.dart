import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/main_drawer.dart';

import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  const ProductsOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _filterOptions = FilterOptions.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Products Overview'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                _filterOptions = value;
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<Carts>(
            builder: (ctx, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      body: ProductsGrid(
        filterOptions: _filterOptions,
      ),
    );
  }
}
