import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.provider.dart';
import '../providers/carts.provider.dart';
import '../providers/product.provider.dart';
import '../screens/product_detail.screen.dart';

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
    final scaffold = ScaffoldMessenger.of(context);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
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
              onPressed: () async {
                try {
                  await productItem.toggleFavoriteStatus(
                    auth.token,
                    auth.userId,
                  );
                } catch (err) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Failed to update favorite status - try again later',
                      ),
                    ),
                  );
                }
                // refereshFunction();
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${product.title} added to cart',
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.updateQuantity(product.id, -1);
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
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
