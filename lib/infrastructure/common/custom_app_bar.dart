import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

import '../theme/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return AppBar(
      backgroundColor: Colors.blueAccent,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            spacing: 5.w,
            children: <Widget>[
              // Custom menu icon on the left
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 19.px, fontWeight: FontWeight.bold),
              ),

              // Title in the center
              const Expanded(child: Center(child: CupertinoTextField())),

              IconButton(
                icon: const Icon(Icons.dark_mode, size: 25, color: Colors.white),
                onPressed: themeController.toggleTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66); // Set the height of the AppBar
}
