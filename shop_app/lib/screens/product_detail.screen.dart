import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final productsProvider = Provider.of<Products>(context, listen: false);
    final product = productsProvider.getOneById(productId);

    Future<void> trigger() async {
      print('triggering');
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            onStretchTrigger: trigger,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.secondary,
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: productId,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                const SizedBox(
                  height: 1000,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
