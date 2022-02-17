import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Function refereshFunction;
  const ProductItem({
    Key? key,
    required this.refereshFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Carts>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, productItem, child) => IconButton(
              icon: Icon(
                productItem.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                productItem.toggleFavoriteStatus();
                refereshFunction();
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () => cart.addItem(
              product.id,
              product.price,
              product.title,
            ),
          ),
          title: FittedBox(
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
