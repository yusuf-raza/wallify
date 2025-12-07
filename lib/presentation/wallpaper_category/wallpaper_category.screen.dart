import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';

class WallpaperCategoryScreen extends StatelessWidget {
  const WallpaperCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Text(AppStrings.wallpaperCategoryScreen, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
