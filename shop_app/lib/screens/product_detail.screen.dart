import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 350,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
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
            )
          ],
        ),
      ),
    );
  }
}
