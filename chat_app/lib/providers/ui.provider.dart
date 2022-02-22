import 'package:flutter/material.dart';

class UI with ChangeNotifier {
  bool _isDarkMode = false;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  bool get isDarkMode {
    return _isDarkMode;
  }
}
