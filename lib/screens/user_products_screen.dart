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
import '../widgets/list_tile_skelleton.dart';

class UserProductsScreen extends StatefulWidget {
  /* Properties */
  static const routeName = '/user/products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  /* Properties */
  Future _productsFuture;

  /* Methods */
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  Future _obtainFuture() {
    return Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  initState() {
    _productsFuture = _obtainFuture();
    super.initState();
  }

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

    return Scaffold(
      appBar: appbar,
      drawer: MainDrawer(_mediaQuery.padding.top),
      body: SafeArea(
        child: FutureBuilder(
            future: _productsFuture,
            builder: (_, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return FittedBox(
                  child: FittedBox(
                    child: ListStileSkelleton(),
                  ),
                );
              } else if (dataSnapshot.hasError) {
                return Center(
                  child: Text('An Error Occured'),
                );
              } else {
                return Container(
                  child: LiquidPullToRefresh(
                    springAnimationDurationInMilliseconds: 900,
                    animSpeedFactor: 8,
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, products, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemExtent: 110.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          itemCount: products.getAllProducts.length,
                          itemBuilder: (_, i) {
                            return UserProductItem(product: products.getAllProducts[i]);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
