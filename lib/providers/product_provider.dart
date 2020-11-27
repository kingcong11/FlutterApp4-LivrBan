import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleIsFavorite() async {
    final url = 'https://flutter-livrban.firebaseio.com/products/$id.json';

    try {
      isFavorite = !isFavorite;
      notifyListeners();

      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );

      if(response.statusCode >= 400){
        /* if something went wrong and failed patch. restore the state from memory */
        isFavorite = !isFavorite;
        notifyListeners();
        throw new HttpException('Something went wrong when adding item to wishlist.');
      }
    } catch (error) {
      throw error;
    }
  }
}
