import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category_view_model.dart';

class WallpaperCategoryScreen extends StatelessWidget {
  const WallpaperCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final WallpaperCategoryViewModel categoryViewModel = Provider.of<WallpaperCategoryViewModel>(
      context,
    );
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('WallpaperCategoryScreen is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
