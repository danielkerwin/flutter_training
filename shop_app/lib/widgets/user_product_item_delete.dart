import 'package:flutter/material.dart';

import '../providers/products.provider.dart';

class UserProductItemDelete extends StatelessWidget {
  final Products products;
  final String productId;

  const UserProductItemDelete({
    Key? key,
    required this.products,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return IconButton(
      onPressed: () async {
        try {
          await products.removeOne(productId);
        } catch (e) {
          scaffold.hideCurrentSnackBar();
          scaffold.showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to delete product - please try again later'),
            ),
          );
        }
      },
      icon: Icon(
        Icons.delete,
        color: Theme.of(context).errorColor,
      ),
    );
  }
}
