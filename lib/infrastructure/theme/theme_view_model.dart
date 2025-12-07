import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallify/infrastructure/constants/shared_prefs_keys.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeViewModel() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(SharedPrefsKeys.isDarkMode) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefsKeys.isDarkMode, _isDarkMode);
    notifyListeners();
  }
}
