import 'package:flutter/material.dart';

/* Packages */
import 'dart:convert';
import 'package:http/http.dart' as http;

/* Models */
import './product_provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Valmy Sofa Beige',
        description: 'A red shirt - it is pretty red!',
        price: 629.99,
        imageUrl: 'assets/images/products/1-removebg-preview.png'),
    Product(
        id: 'p2',
        title: 'Vanity Gray',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl: 'assets/images/products/2-removebg-preview.png'),
    Product(
        id: 'p3',
        title: 'Gray Shade',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl: 'assets/images/products/3-removebg-preview.png'),
    Product(
        id: 'p4',
        title: 'Deep Blue Wood',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'assets/images/products/4-removebg-preview.png'),
    Product(
        id: 'p5',
        title: 'Illutionist Gray',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'assets/images/products/5-removebg-preview.png'),
    Product(
        id: 'p6',
        title: 'Pearl White',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'assets/images/products/6-removebg-preview.png'),
    Product(
        id: 'p7',
        title: 'Mustard Couch',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'assets/images/products/7-removebg-preview.png'),
    Product(
        id: 'p8',
        title: 'Orange Madness',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'assets/images/products/8-removebg-preview.png'),
    Product(
        id: 'p9',
        title: 'Chesnut Comfort',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'assets/images/products/9-removebg-preview.png'),
  ];

  List<Product> get getAllProducts {
    // only returns the copy of the private property _items so that only in this class we can change
    // the values of our proivate property and then notify all the listeners to this class, because if
    // we pass the original private property _items, hence we didn't know where or when the changes triggered
    // and we cant notify the listeners the something changed/happened.
    return [..._items];
  }

  List<Product> get getAllFavoriteProducts {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) {
    const url = 'https://flutter-livrban.firebaseio.com/products';
    return http.post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    ).then((res) {
      var response = json.decode(res.body);

      final newProduct = Product(
        id: response['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error){
      /* I placed the catch after the then method because if I placed the catch right after the post method, the then method 
      will be excuted anyway right after my catch method resolves. placing the catch method at the end will skip suceeding 
      then methods. which in this case, we do not want to happen. eg failing the post request but local adding of product
      still persists if we place the catch right after post method. */
      throw error;
    });
  }

  void updateProduct(String productId, Product newProduct) {
    // returns -1 if nothing is found
    final prodIndex = _items.indexWhere((product) => product.id == productId);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}
