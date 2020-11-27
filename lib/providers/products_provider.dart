import 'package:flutter/material.dart';

/* Packages */
import 'dart:convert';
import 'package:http/http.dart' as http;

/* Models */
import './product_provider.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Valmy Sofa Beige',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 629.99,
    //     imageUrl: 'assets/images/products/1-removebg-preview.png'),
    // Product(
    //     id: 'p2',
    //     title: 'Vanity Gray',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl: 'assets/images/products/2-removebg-preview.png'),
    // Product(
    //     id: 'p3',
    //     title: 'Gray Shade',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl: 'assets/images/products/3-removebg-preview.png'),
    // Product(
    //     id: 'p4',
    //     title: 'Deep Blue Wood',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl: 'assets/images/products/4-removebg-preview.png'),
    // Product(
    //     id: 'p5',
    //     title: 'Illutionist Gray',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl: 'assets/images/products/5-removebg-preview.png'),
    // Product(
    //     id: 'p6',
    //     title: 'Pearl White',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl: 'assets/images/products/6-removebg-preview.png'),
    // Product(
    //     id: 'p7',
    //     title: 'Mustard Couch',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl: 'assets/images/products/7-removebg-preview.png'),
    // Product(
    //     id: 'p8',
    //     title: 'Orange Madness',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl: 'assets/images/products/8-removebg-preview.png'),
    // Product(
    //     id: 'p9',
    //     title: 'Chesnut Comfort',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl: 'assets/images/products/9-removebg-preview.png'),
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

  Future<void> fetchAndSetProduct() async {
    const url = 'https://flutter-livrban.firebaseio.com/products.json';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)
          as Map<String, dynamic>; // Object and dynamic is the same.
      final List<Product> loadedProduct = [];

      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });

      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-livrban.firebaseio.com/products.json';

    try {
      /* await keyword means that we need to wait for this operation to finished first before we continue on the succeding operation */
      final response = await http.post(
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
      );

      var decodedResponse = json.decode(response.body);

      final newProduct = Product(
        id: decodedResponse['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final url =
        'https://flutter-livrban.firebaseio.com/products/$productId.json';

    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );

      // returns -1 if nothing is found
      final prodIndex = _items.indexWhere((product) => product.id == productId);
      if (prodIndex >= 0) {
        _items[prodIndex] = newProduct;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = 'https://flutter-livrban.firebaseio.com/products/$productId';

    /* implementing optimistic updating */
    try {
      final _tempIndexHolder = _items.indexWhere((product) => product.id == productId);
      var _tempProductHolder = _items[_tempIndexHolder];

      _items.removeWhere((product) => product.id == productId);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        /* if something went wrong and failed to delete. restore the item from memory */
        _items.insert(_tempIndexHolder, _tempProductHolder);
        notifyListeners();
        throw new HttpException('Something went wrong deleting product.');
      }
    } catch (error) {
      throw error;
    }
  }
}
