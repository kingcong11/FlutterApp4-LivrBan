import 'dart:convert';

/* Packages */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/* Models */
import '../models/http_exception.dart';

class AuthenticationService with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

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
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(extractedResponse['expiresIn'])));
      }

      _autoSignOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });

      prefs.setString('userData', userData);
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

  Future<void> signOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoSignOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final expiresIn = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: expiresIn), signOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

      if (expiryDate.isAfter(DateTime.now())) {
        /* Reauthenticate User */
        _token = extractedUserData['token']; //this is for the user's login
        _userId = extractedUserData['userId']; // id of the user
        _expiryDate = expiryDate;
        notifyListeners();
        _autoSignOut();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
