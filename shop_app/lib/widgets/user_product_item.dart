import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.provider.dart';
import 'package:shop_app/screens/edit_product.screen.dart';
import 'package:shop_app/widgets/user_product_item_delete.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  const UserProductItem({
    Key? key,
    required this.productId,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: productId,
              ),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            UserProductItemDelete(
              products: products,
              productId: productId,
            ),
          ],
        ),
      ),
    );
  }
}
