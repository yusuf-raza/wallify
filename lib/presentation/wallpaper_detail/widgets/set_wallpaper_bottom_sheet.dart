import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(AppStrings.setAsHomeScreen),
              onTap: () {
                viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.homeScreen);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: Text(AppStrings.setAsLockScreen),
              onTap: () {
                viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.lockScreen);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(AppStrings.setAsBoth),
              onTap: () {
                viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.bothScreens);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
