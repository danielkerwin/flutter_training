import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.model.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    final currentDate = DateTime.now();
    if (_expiryDate != null && _token != null) {
      if (_expiryDate!.isAfter(currentDate)) {
        return _token;
      }
    }
    return null;
  }

  String? get userId {
    return token != null ? _userId : null;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userDataKey);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(userDataKey)) {
      return false;
    }
    final userData = json.decode(prefs.getString(userDataKey) as String)
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiresIn']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _initAuthData(userData['token'], userData['userId'], expiryDate);
    _autoLogout();
    notifyListeners();
    return true;
  }

  void _initAuthData(String token, String userId, DateTime expiryDate) {
    _token = token;
    _expiryDate = expiryDate;
    _userId = userId;
  }

  String _getAuthUrl(AuthMode method) {
    switch (method) {
      case AuthMode.login:
        return Api.signin;
      case AuthMode.signup:
        return Api.signup;
    }
  }

  Future<void> authenticate(
    String email,
    String password,
    AuthMode method,
  ) async {
    try {
      final apiKey = dotenv.get('API_KEY');
      final url = Uri.parse('${_getAuthUrl(method)}?key=$apiKey');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      if (response.statusCode >= 400) {
        final body = json.decode(response.body);
        var message = 'Failed to login - please try again later';
        switch (body['error']?['message']) {
          case 'INVALID_EMAIL':
          case 'INVALID_PASSWORD':
            message = 'Email or password is invalid';
            break;
        }
        print(response.body.toString());
        throw HttpException(message);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(data['expiresIn'])),
      );
      _initAuthData(data['idToken'], data['localId'], expiryDate);
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiresIn': expiryDate.toIso8601String(),
      });
      prefs.setString(userDataKey, userData);
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
