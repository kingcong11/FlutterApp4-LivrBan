import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/* Models */
import '../models/product.dart';

/* Widgets */
import '../widgets/main_drawer.dart';
import '../widgets/homepage_banner.dart';
import '../widgets/product_item_card.dart';

class HomePageScreen extends StatelessWidget {
  /* Properties */
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'Valmy Sofa Beige',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:'assets/images/products/1-removebg-preview.png'
    ),
    Product(
      id: 'p2',
      title: 'Vanity Gray',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:'assets/images/products/2-removebg-preview.png'
    ),
    Product(
      id: 'p3',
      title: 'Gray Shade',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:'assets/images/products/3-removebg-preview.png'
    ),
    Product(
      id: 'p4',
      title: 'Deep Blue Wood',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:'assets/images/products/4-removebg-preview.png'
    ),
    Product(
      id: 'p5',
      title: 'Illutionist Gray',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:'assets/images/products/5-removebg-preview.png'
    ),
    Product(
      id: 'p6',
      title: 'Pearl White',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:'assets/images/products/6-removebg-preview.png'
    ),
    Product(
      id: 'p7',
      title: 'Mustard Couch',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:'assets/images/products/7-removebg-preview.png'
    ),
    Product(
      id: 'p8',
      title: 'Orange Madness',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:'assets/images/products/8-removebg-preview.png'
    ),
    Product(
      id: 'p9',
      title: 'Chesnut Comfort',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:'assets/images/products/9-removebg-preview.png'
    ),
  ];

  /* Builders */
  Widget appbarBuilder(BuildContext context) {
    return AppBar(
      title: Text(
        'LivrBan',
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(FeatherIcons.shoppingBag),
          onPressed: () {},
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
                child: Row(
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      FeatherIcons.filter,
                      color: Colors.white,
                      size: 19,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Sort by',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      MdiIcons.sortReverseVariant,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),
              Container(
                // height: availableContentSize * .63,
                height: availableContentSize * 1,
                padding: const EdgeInsets.all(25),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 10,
                  itemCount: loadedProducts.length,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (ctx, index) {
                    return ProductItemCard(
                      id: loadedProducts[index].id,
                      title: loadedProducts[index].title,
                      price: loadedProducts[index].price,
                      imageUrl: loadedProducts[index].imageUrl,
                    );
                  },
                  staggeredTileBuilder: (int index) {
                    return StaggeredTile.count(5, index.isEven ? 7 : 5);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
