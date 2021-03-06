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
import '../widgets/list_tile_skelleton.dart';

class OrdersScreen extends StatefulWidget {
  /* Properties */
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  /* Properties */
  Future _ordersFuture;
  
  /* Methods */
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }


  @override
  initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

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

    return Scaffold(
      appBar: appbar,
      drawer: MainDrawer(_mediaQuery.padding.top),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder(
                future: _ordersFuture,
                builder: (_, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return FittedBox(
                      child: FittedBox(
                        child: ListStileSkelleton(),
                      ),
                    );
                  } else if (dataSnapshot.hasError) {
                    // improve this later
                    return Center(
                      child: Text('An Error Occured'),
                    );
                  } else {
                    return Consumer<Orders>(
                      builder: (ctx, orderData, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: (orderData.getAllOrders.length > 0)
                              ? ListView.builder(
                                  itemCount: orderData.getAllOrders.length,
                                  itemBuilder: (ctx, i) {
                                    return OrderItemCard(order: orderData.getAllOrders[i]);
                                  },
                                )
                              : EmptyBagSection(
                                  availableContentSize: availableContentSize),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
