import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeController = Provider.of<ThemeViewModel>(context);

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
