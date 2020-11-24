import 'package:flutter/material.dart';

/* Packages */
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

/* Providers */
import '../providers/orders_provider.dart';

/* Widgets */
import '../widgets/bag_item_card.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem order;

  const OrderItemCard({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totalOrderUnitQuantity = 0;
    var totalPrice = FlutterMoneyFormatter(
      amount: order.amount,
      settings: MoneyFormatterSettings(
        symbol: 'Php',
        thousandSeparator: ', ',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 2,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 7,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: 'Order: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: order.id,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    children: [
                      TextSpan(text: 'Placed on'),
                      TextSpan(
                          text:
                              ' ${DateFormat("MMM dd, yyyy - hh:mm a").format(order.dateOrdered)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
            child: Column(
              children: [
                ...order.products.map((op) {
                  totalOrderUnitQuantity += op.quantity;
                  return BagItemCard(
                    id: op.id,
                    imageURL: op.imageURL,
                    price: op.price,
                    productId: op.id,
                    quantity: op.quantity,
                    title: op.title,
                    prefferedHeight: 100,
                    showDecoration: false,
                    isDismissible: false,
                  );
                }).toList(),
                Divider(
                  color: Colors.grey[600],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (totalOrderUnitQuantity > 1)
                        ? Text('$totalOrderUnitQuantity items, ')
                        : Text('$totalOrderUnitQuantity item, '),
                    Text(
                      totalPrice.output.symbolOnLeft,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
