import 'package:flutter/material.dart';

/* Packages */
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

/* Providers */
import '../providers/products_provider.dart';
import '../providers/product_provider.dart';

/* Models */

/* Widgets */
import 'product_item_card.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.getAllProducts;

    return StaggeredGridView.countBuilder(
      crossAxisCount: 10,
      itemCount: products.length,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider(
          create: (ctx) => products[index],
          child: ProductItemCard(
            // id: products[index].id,
            // title: products[index].title,
            // price: products[index].price,
            // imageUrl: products[index].imageUrl,
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(5, index.isEven ? 7 : 5);
      },
    );
  }
}
