import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiresIn;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    final currentDate = DateTime.now();
    if (_expiresIn != null && _token != null) {
      if (_expiresIn!.isAfter(currentDate)) {
        return _token;
      }
    }
    return null;
  }

  void logout() {
    _token = null;
    _expiresIn = null;
    _userId = null;
    notifyListeners();
  }

  Future _login(Uri url, String email, String password) async {
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final data = json.decode(response.body) as Map<String, dynamic>;
    _token = data['idToken'];
    _expiresIn = DateTime.now().add(
      Duration(
        seconds: int.parse(data['expiresIn']),
      ),
    );
    _userId = data['localId'];
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse('${Api.signup}?key=$apiKey');
    await _login(url, email, password);
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('${Api.signin}?key=$apiKey');
    await _login(url, email, password);
  }
}
