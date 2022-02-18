import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.provider.dart';
import 'package:shop_app/providers/carts.provider.dart';
import 'package:shop_app/providers/orders.provider.dart';
import 'package:shop_app/providers/products.provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart.screen.dart';
import 'package:shop_app/screens/edit_product.screen.dart';
import 'package:shop_app/screens/orders.screen.dart';
import 'package:shop_app/screens/product_detail.screen.dart';
import 'package:shop_app/screens/products_overview.screen.dart';
import 'package:shop_app/screens/user_products.screen.dart';

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
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, products) {
            products?.authToken = auth.token;
            return products as Products;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, orders) {
            orders?.authToken = auth.token;
            return orders as Orders;
          },
        ),
        ChangeNotifierProvider<Carts>(create: (_) => Carts()),
      ],
      child: Consumer<Auth>(
          builder: (_, auth, __) => MaterialApp(
                title: 'MyShop',
                theme: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    secondary: Colors.redAccent,
                  ),
                ),
                home: auth.isAuth
                    ? const ProductsOverviewScreen()
                    : const AuthScreen(),
                routes: {
                  ProductsOverviewScreen.routeName: (ctx) =>
                      const ProductsOverviewScreen(),
                  ProductDetailScreen.routeName: (ctx) =>
                      const ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => const CartScreen(),
                  OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                  UserProductsScreen.routeName: (ctx) =>
                      const UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) =>
                      const EditProductScreen(),
                  AuthScreen.routeName: (ctx) => const AuthScreen(),
                },
              )),
    );
  }
}
