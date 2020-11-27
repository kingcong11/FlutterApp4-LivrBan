import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-livrban.firebaseio.com/orders.json';

    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateOrdered: DateTime.parse(orderData['dateOrdered']),
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
              imageURL: item['imageURL'],
            );
          }).toList(),
        ));
      });

      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    const url = 'https://flutter-livrban.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': totalAmount,
            'dateOrdered': timeStamp.toIso8601String(),
            'products': cartProducts.map((cp) {
              return {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
                'imageURL': cp.imageURL,
              };
            }).toList(),
          },
        ),
      );

      _orders.add(OrderItem(
        id: json.decode(response.body)['name'],
        products: cartProducts,
        amount: totalAmount,
        dateOrdered: timeStamp,
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }

    // _orders.add(OrderItem(
    // id: DateTime.now().toString(),
    //   products: prodcartProductsucts,
    //   amount: totalAmount,
    //   dateOrdered: timeStamp,
    // ));
    // notifyListeners();
  }
}
