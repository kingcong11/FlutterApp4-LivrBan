import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Providers */
import '../providers/cart_provider.dart';

/* Screens */
import '../screens/my_bag_screen.dart';

/* Widgets */
import '../widgets/main_drawer.dart';
import '../widgets/homepage_banner.dart';
import '../widgets/products_gridview.dart';
import '../widgets/products_gridview_filter.dart';
import '../widgets/badge.dart';

enum ProductOptions { All, Favorites }

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  /* Properties */
  var _showFavoritesOnly = false;

  /* Builders */
  Widget appbarBuilder(BuildContext context) {
    return AppBar(
      title: Text(
        'LivrBan',
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        Consumer<Cart>(
          builder: (context, cart, child) {
            return Badge(
              child: child,
              color: Color(0xFFf1e3cb),
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
        PopupMenuButton(
          icon: Icon(FeatherIcons.moreVertical),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Text('All Products'),
                  Spacer(),
                  Icon(
                    FeatherIcons.layers,
                    size: 20,
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
              value: ProductOptions.All,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Text('Wishlist'),
                  Spacer(),
                  Icon(
                    FeatherIcons.heart,
                    size: 20,
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
              value: ProductOptions.Favorites,
            )
          ],
          onSelected: (selectedValue) {
            setState(() {
              if (selectedValue == ProductOptions.Favorites) {
                _showFavoritesOnly = true;
              } else {
                _showFavoritesOnly = false;
              }
            });
          },
        ),
      ],
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  /* Getters */
  double _computeMainContentSize(MediaQueryData mediaQuery, AppBar appbar) {
    return (mediaQuery.size.height -
        (appbar.preferredSize.height + mediaQuery.padding.top));
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final appbar = appbarBuilder(context);
    final availableContentSize = _computeMainContentSize(_mediaQuery, appbar);

    return Scaffold(
      appBar: appbar,
      drawer: MainDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: availableContentSize * .3,
                child: HomepageBanner(),
              ),
              Container(
                height: availableContentSize * .07,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProductsGridFilters(),
              ),
              Container(
                // height: availableContentSize * .63,
                height: availableContentSize * 1,
                padding: const EdgeInsets.all(25),
                child: ProductsGrid(_showFavoritesOnly),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
