import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // RxBool to track theme state (dark or light)
  RxBool isDarkMode = false.obs;

  // Get current theme based on the isDarkMode state
  ThemeData get currentTheme => isDarkMode.value ? ThemeData.dark() : ThemeData.light();

  // Get current theme based on the isDarkMode state
  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // Method to toggle the theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? ThemeData.light() : ThemeData.dark());
  }
}
