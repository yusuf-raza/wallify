import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel controller, Widget? child) {
        return Scaffold(
          body: IndexedStack(index: controller.currentIndex, children: controller.screens),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: controller.currentIndex,
            onTap: (int index) {
              controller.changeIndex(index);
            },
            items: <SalomonBottomBarItem>[
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: Text(AppStrings.home),
                selectedColor: AppColors.purple,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.category),
                title: Text(AppStrings.category),
                selectedColor: AppColors.pink,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite),
                title: Text(AppStrings.favourite),
                selectedColor: AppColors.orange,
              ),
            ],
          ),
        );
      },
    );
  }
}
