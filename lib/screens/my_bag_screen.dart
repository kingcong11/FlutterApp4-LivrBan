import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

/* Providers */
import '../providers/cart_provider.dart';

/* Widgets */
import '../widgets/badge.dart';
import '../widgets/bag_item_card.dart';
import '../widgets/bag_checkout_section.dart';
import '../widgets/empty_bag_section.dart';

class MyBagScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/my-bag';

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
            onPressed: () {},
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
    final _mediaQuery = MediaQuery.of(context);
    final appbar = appbarBuilder(context);
    final availableContentSize = _computeMainContentSize(_mediaQuery, appbar);
    final cartData = Provider.of<Cart>(context);

    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
      amount: cartData.cartTotal,
      settings: MoneyFormatterSettings(
        symbol: 'Php',
        thousandSeparator: ', ',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 2,
      ),
    );

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: (cartData.itemCount > 0)
                    ? ListView.builder(
                        itemCount: cartData.itemCount,
                        itemBuilder: (context, index) {
                          return BagItemCard(
                            productId:
                                cartData.getAllCartItems.keys.toList()[index],
                            id: cartData.getAllCartItems.values
                                .toList()[index]
                                .id,
                            price: cartData.getAllCartItems.values
                                .toList()[index]
                                .price,
                            quantity: cartData.getAllCartItems.values
                                .toList()[index]
                                .quantity,
                            title: cartData.getAllCartItems.values
                                .toList()[index]
                                .title,
                            imageURL: cartData.getAllCartItems.values
                                .toList()[index]
                                .imageURL,
                            key: ValueKey(cartData.getAllCartItems.values
                                .toList()[index]
                                .id),
                          );
                        })
                    : EmptyBagSection(availableContentSize: availableContentSize),
              ),
            ),
            if (cartData.itemCount > 0)
              Container(
                height: availableContentSize * .15,
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                color: Colors.white,
                child: BagCheckoutSection(cartData: cartData, fmf: fmf),
              ),
          ],
        ),
      ),
    );
  }
}