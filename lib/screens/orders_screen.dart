import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Screens */
import './my_bag_screen.dart';

/* Providers */
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

/* Widgets */
import '../widgets/badge.dart';
import '../widgets/main_drawer.dart';
import '../widgets/empty_bag_section.dart';
import '../widgets/order_item_card.dart';

class OrdersScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/orders';

  /* Builders */
  Widget appbarBuilder(BuildContext context) {
    return AppBar(
      title: Text(
        'LivrBan',
        style: TextStyle(fontSize: 25),
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
    );
  }

  /* Getters */
  double _computeMainContentSize(MediaQueryData mediaQuery, AppBar appbar) {
    return (mediaQuery.size.height -
        (appbar.preferredSize.height + mediaQuery.padding.top));
  }

  @override
  Widget build(BuildContext context) {
    final appbar = appbarBuilder(context);
    final _mediaQuery = MediaQuery.of(context);
    final double availableContentSize = _computeMainContentSize(_mediaQuery, appbar);
    final orderData = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: appbar,
      drawer: MainDrawer(_mediaQuery.padding.top),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: (orderData.getAllOrders.length > 0) ? ListView.builder(
                  itemCount: orderData.getAllOrders.length,
                  itemBuilder: (ctx, i) {
                    return OrderItemCard(order: orderData.getAllOrders[i]);
                  },
                ) : EmptyBagSection(availableContentSize: availableContentSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
