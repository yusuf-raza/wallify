import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/navigation/routes.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() => ThemeController());
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          crossAxisSpacing: 5, // Horizontal spacing between items
          mainAxisSpacing: 5, // Vertical spacing between items
          childAspectRatio: 0.6,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        itemCount: 100, // Number of grid items
        itemBuilder: (BuildContext context, int index) {
          return GridItem(
            index: index,
            onTap: () {
              Get.toNamed(Routes.WALLPAPER_DETAIL);
            },
          );
        },
      ),
    );
  }
}
