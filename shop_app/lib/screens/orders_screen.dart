import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) => OrderItem(order: orders.items[idx]),
        itemCount: orders.items.length,
      ),
    );
  }
}
