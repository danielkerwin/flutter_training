import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'helpers/custom_route.dart';
import 'providers/auth.provider.dart';
import 'providers/carts.provider.dart';
import 'providers/orders.provider.dart';
import 'providers/products.provider.dart';
import 'screens/auth_screen.dart';
import 'screens/cart.screen.dart';
import 'screens/edit_product.screen.dart';
import 'screens/orders.screen.dart';
import 'screens/product_detail.screen.dart';
import 'screens/products_overview.screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products.screen.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      fontFamily: 'Lato',
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          TargetPlatform.android: CustomPageTransitionsBuilder(),
        },
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, products) {
            products?.authToken = auth.token;
            products?.userId = auth.userId;
            return products as Products;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, orders) {
            orders?.authToken = auth.token;
            orders?.userId = auth.userId;
            return orders as Orders;
          },
        ),
        ChangeNotifierProvider<Carts>(create: (_) => Carts()),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          ifAuth(targetScreen) =>
              auth.isAuth ? targetScreen : const AuthScreen();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                secondary: Colors.redAccent,
              ),
            ),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SplashScreen();
                      }
                      return const AuthScreen();
                    },
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) =>
                  ifAuth(const ProductDetailScreen()),
              CartScreen.routeName: (ctx) => ifAuth(const CartScreen()),
              OrdersScreen.routeName: (ctx) => ifAuth(const OrdersScreen()),
              UserProductsScreen.routeName: (ctx) =>
                  ifAuth(const UserProductsScreen()),
              EditProductScreen.routeName: (ctx) =>
                  ifAuth(const EditProductScreen()),
            },
          );
        },
      ),
    );
  }
}
