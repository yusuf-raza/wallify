import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
