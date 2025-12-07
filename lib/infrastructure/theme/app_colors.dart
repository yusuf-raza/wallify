import 'package:flutter/material.dart';

// This class contains all the colors used in the app.
// This is a good practice for managing colors and for theming.
class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;
  static const Color orange = Colors.orange;
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color transparent = Colors.transparent;
  static final Color blackWithOpacity = Colors.black.withOpacity(0.5);

  static Color fromHex(String hex) {
    return Color(int.parse('0xFF${hex.replaceFirst('#', '')}'));
  }
}
