import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

/* Providers */
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

/* Screens */
import '../screens/my_bag_screen.dart';

/* Widgets */
import '../widgets/main_drawer.dart';
import '../widgets/homepage_banner.dart';
import '../widgets/products_gridview.dart';
import '../widgets/products_gridview_filter.dart';
import '../widgets/badge.dart';
import '../widgets/loading_products_gridview.dart';

enum ProductOptions { All, Favorites }

class HomePageScreen extends StatefulWidget {
  /* Properties */
  static const routeName = '/homepage';
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  /* Properties */
  var _showFavoritesOnly = false;
  var _isLoading = true;

  // @override
  // initState() {
  //   Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
  //     print('Products Loaded.');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }
  @override
  initState() {
    try {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        print('Products Loaded.');
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  /* Methods */
  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

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
              color: Color(0xFF17786D),
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
      drawer: MainDrawer(_mediaQuery.padding.top),
      body: SafeArea(
        child: LiquidPullToRefresh(
          backgroundColor: Color(0xFF1abf8a),
          onRefresh: _refreshProducts,
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 900,
          animSpeedFactor: 8,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
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
                (_isLoading)
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          child: LoadingProductsGrid(),
                        ),
                      )
                    : Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          child: ProductsGrid(_showFavoritesOnly),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
