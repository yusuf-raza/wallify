import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

void showSetWallpaperBottomSheet(
  BuildContext context,
  WallpaperDetailViewModel viewModel,
  String imageUrl,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[AppColors.purple, AppColors.pink, AppColors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: Text(
                  AppStrings.setAsHomeScreen,
                  style: AppTextStyles.listItem.copyWith(color: Colors.white),
                ),
                onTap: () {
                  viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.homeScreen);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: Text(
                  AppStrings.setAsLockScreen,
                  style: AppTextStyles.listItem.copyWith(color: Colors.white),
                ),
                onTap: () {
                  viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.lockScreen);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.white),
                title: Text(
                  AppStrings.setAsBoth,
                  style: AppTextStyles.listItem.copyWith(color: Colors.white),
                ),
                onTap: () {
                  viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.bothScreens);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
