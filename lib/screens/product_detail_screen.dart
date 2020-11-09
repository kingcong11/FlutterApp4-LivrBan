import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

/* Packages */
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ProductDetailScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/product-detail';

  /* Builders */
  Widget appbarBuilder(BuildContext context) {
    return AppBar(
      title: Text(
        'LivrBan',
        style: TextStyle(fontSize: 25),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(FeatherIcons.shoppingBag),
          onPressed: () {},
        ),
      ],
      elevation: 0,
      // iconTheme: IconThemeData(color: Colors.white),
      // backgroundColor: Theme.of(context).accentColor,
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
    final productId = ModalRoute.of(context).settings.arguments as  String;
    final loadedProduct = productsProvider.findById(productId);
    final _mediaQuery = MediaQuery.of(context);
    final appbar = appbarBuilder(context);
    final availableContentSize = _computeMainContentSize(_mediaQuery, appbar);

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: availableContentSize * .45,
                color: Colors.lime,
                child: Text(productId),
              )
            ],
          ),
        ),
      ),
    );
  }
}
