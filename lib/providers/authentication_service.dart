import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthenticationService with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final String apiKey = DotEnv().env['API_KEY'];


  Future<void> authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email.trim(),
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      var extractedResponse = json.decode(response.body);

      if (extractedResponse['error'] != null) {
        throw new HttpException(extractedResponse['error']['message']);
      } else {
        /* Authenticate User */
        _token = extractedResponse['idToken']; //this is for the user's login
        _userId = extractedResponse['localId']; // id of the user
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(extractedResponse['expiresIn'])));
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signIn({
    @required String email,
    @required String password,
  }) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp({
    @required String email,
    @required String password,
  }) async {
    return authenticate(email, password, 'signUp');
  }

  signOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;

    notifyListeners();
  }

  bool get isAuthenticated {
    // validate token
    return (token != null);
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }
}
