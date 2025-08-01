import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/common/custom_app_bar.dart';
import 'controllers/wallpaper_category.controller.dart';

class WallpaperCategoryScreen extends GetView<WallpaperCategoryController> {
  const WallpaperCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'WallApp.'),
      body: const Center(
        child: Text(
          'WallpaperCategoryScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
