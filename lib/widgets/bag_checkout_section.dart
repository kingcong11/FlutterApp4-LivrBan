import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

/* Providers */
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

class BagCheckoutSection extends StatelessWidget {
  const BagCheckoutSection({
    Key key,
    @required this.cartData,
    @required this.fmf,
  }) : super(key: key);

  final Cart cartData;
  final FlutterMoneyFormatter fmf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(
          height: 1,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 4,
            ),
            Text('(Including GST)'),
            Spacer(),
            Text(
              fmf.output.symbolOnLeft,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            child: FlatButton(
              color: Theme.of(context).primaryColor.withOpacity(.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Provider.of<Orders>(context, listen: false).addOrder(
                  cartData.getAllCartItems.values.toList(),
                  cartData.cartTotal,
                );
                cartData.clear();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Order placed successfully.',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  duration: Duration(milliseconds: 3000),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  elevation: 0,
                ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
