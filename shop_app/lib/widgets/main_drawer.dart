import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.provider.dart';
import 'package:shop_app/screens/orders.screen.dart';
import 'package:shop_app/screens/products_overview.screen.dart';
import 'package:shop_app/screens/user_products.screen.dart';

class MainDrawer extends StatelessWidget {
  final menuItems = const [
    {
      'title': 'Shop',
      'iconData': Icons.shop,
      'route': ProductsOverviewScreen.routeName
    },
    {
      'title': 'Orders',
      'iconData': Icons.payment,
      'route': OrdersScreen.routeName
    },
    {
      'title': 'Manage Products',
      'iconData': Icons.edit,
      'route': UserProductsScreen.routeName
    },
  ];

  const MainDrawer({Key? key}) : super(key: key);

  List<Widget> buildListTiles(BuildContext context) {
    return menuItems
        .expand((item) => [
              ListTile(
                title: Text(item['title'] as String),
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(item['route'] as String),
                leading: Icon(item['iconData'] as IconData),
              ),
              const Divider(),
            ])
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
          // ListTile(
          //   title: const Text('Logout'),
          //   onTap: () => Provider.of<Auth>(context, listen: false).logout(),
          //   leading: const Icon(Icons.logout),
          // ),
        ],
      ),
    );
  }
}
