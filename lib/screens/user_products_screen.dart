import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';

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
          onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
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
          child: ListView.builder(
            itemExtent: 110.0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: products.length,
            itemBuilder: (_, i) {
              return UserProductItem(product: products[i]);
            },
          ),
        ),
      ),
    );
  }
}
