import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.provider.dart';
import 'edit_product.screen.dart';
import '../widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something has gone wrong - try again later'),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<Products>(
                builder: (_, products, __) => ListView.builder(
                  itemBuilder: (___, idx) => Column(
                    children: [
                      UserProductItem(
                        productId: products.items[idx].id,
                        title: products.items[idx].title,
                        imageUrl: products.items[idx].imageUrl,
                      ),
                      const Divider(),
                    ],
                  ),
                  itemCount: products.items.length,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
