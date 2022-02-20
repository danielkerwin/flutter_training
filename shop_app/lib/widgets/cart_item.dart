import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carts.provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String cartId;
  final double price;
  final int quantity;
  final String title;

  const CartItem({
    Key? key,
    required this.productId,
    required this.cartId,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartId),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Carts>(context, listen: false).removeProduct(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?!'),
            content: const Text('Do you want to remove the item from cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: FittedBox(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      Provider.of<Carts>(context, listen: false)
                          .updateQuantity(productId, -1);
                    },
                  ),
                  Text('$quantity x'),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {
                      Provider.of<Carts>(context, listen: false)
                          .updateQuantity(productId, 1);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
