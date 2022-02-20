import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carts.provider.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_summary.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<Carts>(context);
    final cartValues = carts.items.values.toList();
    final productIds = carts.items.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          CartSummary(
            totalPrice: carts.totalPrice,
            cartProducts: cartValues,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, idx) => CartItem(
                productId: productIds[idx],
                cartId: cartValues[idx].id,
                title: cartValues[idx].title,
                quantity: cartValues[idx].quantity,
                price: cartValues[idx].price,
              ),
              itemCount: cartValues.length,
            ),
          ),
        ],
      ),
    );
  }
}
