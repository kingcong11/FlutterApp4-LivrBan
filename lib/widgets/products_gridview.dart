import 'package:flutter/material.dart';

/* Packages */
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

/* Providers */
import '../providers/products_provider.dart';

/* Models */

/* Widgets */
import 'product_item_card.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavoritesOnly;

  ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = (showFavoritesOnly)
        ? productsProvider.getAllFavoriteProducts
        : productsProvider.getAllProducts;

    if (showFavoritesOnly && products.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: Text(
          'You have nothing in your wishlist yet..',
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return StaggeredGridView.countBuilder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 10,
        itemCount: products.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItemCard(),
          );
        },
        staggeredTileBuilder: (int index) {
          return StaggeredTile.count(5, index.isEven ? 7 : 5);
        },
      );
    }
  }
}
