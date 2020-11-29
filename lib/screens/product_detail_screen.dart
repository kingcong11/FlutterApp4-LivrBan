import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Providers */
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';

/* Screens */
import './my_bag_screen.dart';

/* Widgets */
import '../widgets/badge.dart';
import '../widgets/my_custom_rating_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/product-detail';

  /* Builders */
  Widget appbarBuilder(BuildContext context) {
    return AppBar(
      title: Text(
        'LivrBan',
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
      centerTitle: true,
      actions: [
        Consumer<Cart>(
          builder: (context, cart, child) {
            return Badge(
              child: child,
              value: cart.itemCount.toString(),
            );
          },
          child: IconButton(
            icon: Icon(FeatherIcons.shoppingBag),
            onPressed: () {
              Navigator.of(context).pushNamed(MyBagScreen.routeName);
            },
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  /* Getters */
  double _computeMainContentSize(MediaQueryData mediaQuery, AppBar appbar) {
    return (mediaQuery.size.height -
        (appbar.preferredSize.height + mediaQuery.padding.top));
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = productsProvider.findById(productId);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final _mediaQuery = MediaQuery.of(context);
    final appbar = appbarBuilder(context);
    final availableContentSize = _computeMainContentSize(_mediaQuery, appbar);

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: availableContentSize * .45,
                      color: Colors.white,
                      child: Image.asset(
                        loadedProduct.imageUrl,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Container(
                      height: availableContentSize * .07,
                    ),
                    Container(
                      height: availableContentSize * .1,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 12,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: constraints.maxHeight * .7,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    loadedProduct.title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: constraints.maxHeight * .3,
                                child: MyCustomRatingBar(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        loadedProduct.description,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: availableContentSize * .09,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '\$ ${loadedProduct.price.toString()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Builder(
                          builder: (context) => OutlineButton(
                            textColor: Colors.black87,
                            highlightColor: Theme.of(context).accentColor,
                            highlightedBorderColor: Colors.black54,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.5,
                              color: Color(0xFF848290),
                            ),
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              cartProvider.addItem(
                                loadedProduct.id,
                                loadedProduct.title,
                                loadedProduct.price,
                                loadedProduct.imageUrl,
                              );
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Container(
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 50),
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF091a2f), //oxford blue
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Succesfully Added your Cart.',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: () => cartProvider
                                            .undoAddToCart(loadedProduct.id),
                                      ),
                                    ],
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                duration: Duration(milliseconds: 4000),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                elevation: 0,
                              ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
