import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.provider.dart';
import 'package:shop_app/providers/products.provider.dart';
import 'package:shop_app/screens/products_overview.screen.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatefulWidget {
  final FilterOptions filterOptions;

  const ProductsGrid({
    Key? key,
    this.filterOptions = FilterOptions.all,
  }) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  refereshFunction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);

    List<Product> products;

    switch (widget.filterOptions) {
      case FilterOptions.all:
        products = productsProvider.items;
        break;
      case FilterOptions.favorites:
        products = productsProvider.favoriteItems;
        break;
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        value: products[idx],
        child: ProductItem(refereshFunction: refereshFunction),
      ),
      itemCount: products.length,
    );
  }
}
