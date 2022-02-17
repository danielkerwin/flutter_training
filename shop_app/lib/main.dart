import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      fontFamily: 'Lato',
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Carts()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.redAccent,
          ),
        ),
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (ctx) =>
              const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
        },
      ),
    );
  }
}
