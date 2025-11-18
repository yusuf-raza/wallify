import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail.controller.dart';

class WallpaperDetailScreen extends StatelessWidget {
  const WallpaperDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final WallpaperDetailController wallpaperDetailController =
        Provider.of<WallpaperDetailController>(context);

    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('WallpaperDetailScreen'), centerTitle: true),
      body: CarouselSlider(
        items: homeViewModel.wallpapers
            .map(
              (WallhavenWallpaper wallpaper) => Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(wallpaper.path!, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Text('${wallpaper.thumbs!.large}'),
                  ),
                ],
              ),
            )
            .toList(),
        options: CarouselOptions(height: 550, aspectRatio: 2.5, enlargeCenterPage: true),
      ),
    );
  }
}
