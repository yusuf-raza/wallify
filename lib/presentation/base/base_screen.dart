import 'package:easy_animated_indexed_stack/easy_animated_indexed_stack.dart';
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
    return Consumer<HomeVM>(
      builder: (BuildContext context, HomeVM controller, Widget? child) {
        return Scaffold(
          body: EasyAnimatedIndexedStack(
            index: controller.currentIndex,
            children: controller.screens,
          ),
          bottomNavigationBar: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double bottomPadding = MediaQuery.of(context).padding.bottom;
              const double barHeight = 55;
              final double totalHeight = barHeight + bottomPadding;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: controller.isBottomBarVisible ? totalHeight : 0,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: controller.isBottomBarVisible ? 1 : 0,
                    child: SalomonBottomBar(
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
