import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.provider.dart';
import 'package:shop_app/providers/orders.provider.dart';

class CartSummarySubmit extends StatefulWidget {
  const CartSummarySubmit({
    Key? key,
    required this.totalPrice,
    required this.cartProducts,
  }) : super(key: key);

  final double totalPrice;
  final List<Cart> cartProducts;

  @override
  State<CartSummarySubmit> createState() => _CartSummarySubmitState();
}

class _CartSummarySubmitState extends State<CartSummarySubmit> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: _isLoading || widget.totalPrice <= 0
          ? null
          : () async {
              String message = 'Order successfully placed';
              scaffold.hideCurrentSnackBar();
              setState(() => _isLoading = true);
              try {
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.cartProducts, widget.totalPrice);
                Provider.of<Carts>(context, listen: false).clear();
              } catch (err) {
                message = 'Failed to create order - please try again later';
              } finally {
                setState(() => _isLoading = false);
                scaffold.showSnackBar(SnackBar(content: Text(message)));
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator.adaptive()
          : const Text(
              'Place Order',
            ),
    );
  }
}
