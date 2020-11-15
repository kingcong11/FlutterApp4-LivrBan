import 'package:flutter/material.dart';

/* Package */
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

/* Providers */
import '../providers/cart_provider.dart';

class BagItemCard extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageURL;
  final String productId;

  const BagItemCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageURL,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formattedPrice = FlutterMoneyFormatter(
      amount: price,
      settings: MoneyFormatterSettings(
        symbol: 'Php',
        thousandSeparator: ', ',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 2,
      ),
    );
    var totalPrice = FlutterMoneyFormatter(
      amount: price * quantity,
      settings: MoneyFormatterSettings(
        symbol: 'Php',
        thousandSeparator: ', ',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 2,
      ),
    );
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        padding: const EdgeInsets.only(right: 15),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 30,
        ),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 7,
            spreadRadius: 1,
          )
        ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 45,
              fit: FlexFit.tight,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  imageURL,
                  fit: BoxFit.scaleDown,
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Flexible(
              flex: 55,
              child: Container(
                // color: Colors.lightGreen,
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text('Price'),
                        Spacer(),
                        Text(formattedPrice.output.nonSymbol),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Quantity'),
                        Spacer(),
                        Text('x $quantity'),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          totalPrice.output.symbolOnLeft,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
