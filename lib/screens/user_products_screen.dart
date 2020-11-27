import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

/* Providers */
import '../providers/products_provider.dart';

/* Screens */
import './edit_product_screen.dart';

/* Widgets */
import '../widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/user/products';

  /* Methods */
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  /* Builders */
  Widget appbarBuilder(BuildContext context) {
    return AppBar(
      title: const Text(
        'LivrBan',
        style: TextStyle(fontSize: 25),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () =>
              Navigator.of(context).pushNamed(EditProductScreen.routeName),
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appbar = appbarBuilder(context);
    final _mediaQuery = MediaQuery.of(context);
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.getAllProducts;

    return Scaffold(
      appBar: appbar,
      drawer: MainDrawer(_mediaQuery.padding.top),
      body: SafeArea(
        child: Container(
          child: LiquidPullToRefresh(
            springAnimationDurationInMilliseconds: 900,
            animSpeedFactor: 8,
            onRefresh: () => _refreshProducts(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemExtent: 110.0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  return UserProductItem(product: products[i]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
