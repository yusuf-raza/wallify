import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/infrastructure/app_strings.dart';
import 'package:wallify/infrastructure/theme/theme_controller.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return AppBar(
      centerTitle: true,
      title: Text(
        AppStrings.appTitle,
        style: TextStyle(fontSize: 100.px, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.dark_mode, size: 25),
          onPressed: themeController.toggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(66.h); // Set the height of the AppBar
}
