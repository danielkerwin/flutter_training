import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Main Menu'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            title: const Text('Shop'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName),
            leading: const Icon(Icons.shop),
          ),
          const Divider(),
          ListTile(
            title: const Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
            leading: const Icon(Icons.payment),
          )
        ],
      ),
    );
  }
}
