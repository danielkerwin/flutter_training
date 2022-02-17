import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';

class CartSummary extends StatelessWidget {
  final double totalPrice;
  final List<Cart> cartProducts;

  const CartSummary({
    Key? key,
    required this.totalPrice,
    required this.cartProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () {
                if (totalPrice > 0) {
                  Provider.of<Orders>(context, listen: false)
                      .addOrder(cartProducts, totalPrice);
                  Provider.of<Carts>(context, listen: false).clear();
                }
              },
              child: const Text(
                'Place Order',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
