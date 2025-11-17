import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail.controller.dart';

class WallpaperDetailScreen extends StatelessWidget {
  const WallpaperDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final WallpaperDetailController wallpaperDetailController =
        Provider.of<WallpaperDetailController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('WallpaperDetailScreen'), centerTitle: true),
      body: CarouselSlider(
        items: wallpaperDetailController.imageSliders,
        options: CarouselOptions(height: 550, aspectRatio: 2.5, enlargeCenterPage: true),
      ),
    );
  }
}
