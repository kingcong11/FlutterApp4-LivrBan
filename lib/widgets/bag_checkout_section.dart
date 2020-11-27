import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

/* Providers */
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

class BagCheckoutSection extends StatefulWidget {
  const BagCheckoutSection({
    Key key,
    @required this.cartData,
    @required this.fmf,
  }) : super(key: key);

  final Cart cartData;
  final FlutterMoneyFormatter fmf;

  @override
  _BagCheckoutSectionState createState() => _BagCheckoutSectionState();
}

class _BagCheckoutSectionState extends State<BagCheckoutSection> {
  /* Properties */
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

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
              widget.fmf.output.symbolOnLeft,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: (_isLoading) ? CircularProgressIndicator() : Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              disabledColor: Color(0xFF7BABE6),
              onPressed: (_isLoading) ? null : () async {
                setState(() {
                  _isLoading = true;
                });

                try {
                  await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cartData.getAllCartItems.values.toList(),
                    widget.cartData.cartTotal,
                  );

                  widget.cartData.clear();

                  scaffold.showSnackBar(SnackBar(
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
                } catch (error) {
                  // show error message here
                }

                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
