import 'package:flutter/material.dart';

/* Providers */
import '../providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateOrdered;

  const OrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.dateOrdered,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getAllOrders {
    return [..._orders];
  }

  void addOrder(List<CartItem> products, double totalAmount) {
    _orders.add(OrderItem(
      id: DateTime.now().toString(),
      products: products,
      amount: totalAmount,
      dateOrdered: DateTime.now(),
    ));
    notifyListeners();
  }
}
