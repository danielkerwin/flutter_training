import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';
import '../providers/auth.provider.dart';
import '../screens/orders.screen.dart';
import '../screens/products_overview.screen.dart';
import '../screens/user_products.screen.dart';

class MainDrawer extends StatelessWidget {
  final menuItems = const [
    {
      'title': 'Shop',
      'iconData': Icons.shop,
      'route': ProductsOverviewScreen(),
    },
    {
      'title': 'Orders',
      'iconData': Icons.payment,
      'route': OrdersScreen(),
    },
    {
      'title': 'Manage Products',
      'iconData': Icons.edit,
      'route': UserProductsScreen(),
    },
  ];

  const MainDrawer({Key? key}) : super(key: key);

  List<Widget> buildListTiles(BuildContext context) {
    return menuItems
        .expand(
          (item) => [
            ListTile(
              title: Text(item['title'] as String),
              onTap: () => Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => item['route'] as Widget,
                ),
              ),
              leading: Icon(item['iconData'] as IconData),
            ),
            const Divider(),
          ],
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Main Menu'),
            automaticallyImplyLeading: false,
          ),
          ...buildListTiles(context),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
