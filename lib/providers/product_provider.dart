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

  Future<void> toggleIsFavorite(String authToken, String userId) async {
    final url = 'https://flutter-livrban.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    try {
      var oldStatus = isFavorite;
      isFavorite = !isFavorite;
      notifyListeners();

      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        /* if something went wrong and failed patch. restore the state from memory */
        isFavorite = !isFavorite;
        notifyListeners();
        if (oldStatus == true) {
          throw new HttpException(
              'Something went wrong removing item to wishlist.');
        } else {
          throw new HttpException(
              'Something went wrong adding item to wishlist.');
        }
      }
    } catch (error) {
      throw error;
    }
  }
}
