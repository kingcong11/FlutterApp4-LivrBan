import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Providers */
// import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

/* Screens */
// import 'my_bag_screen.dart';
import './edit_product_screen.dart';


/* Widgets */
// import '../widgets/badge.dart';
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
        // Consumer<Cart>(
        //   builder: (context, cart, child) {
        //     return Badge(
        //       child: child,
        //       value: cart.itemCount.toString(),
        //     );
        //   },
        //   child: IconButton(
        //     icon: Icon(FeatherIcons.shoppingBag),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(MyBagScreen.routeName);
        //     },
        //   ),
        // ),
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
