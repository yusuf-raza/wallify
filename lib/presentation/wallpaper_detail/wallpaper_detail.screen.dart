import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

class WallpaperDetailScreen extends StatelessWidget {
  const WallpaperDetailScreen({super.key, required this.initialIndex});

  final int initialIndex;
  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WallpaperDetailScreen'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRouter.base);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          CarouselSlider(
            items: homeViewModel.wallpapers
                .map(
                  (WallhavenWallpaper wallpaper) => Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(wallpaper.path!, fit: BoxFit.cover, width: 1000.0),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.3),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 550,
              aspectRatio: 2.5,
              enlargeCenterPage: true,
              initialPage: initialIndex,
            ),
          ),

          Row(
            mainAxisAlignment: .center,
            children: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
              IconButton(
                onPressed: () async {
                  final String imageUrl = 'https://picsum.photos/200/300';
                  final File file = await DefaultCacheManager().getSingleFile(imageUrl);

                  final int location = WallpaperManagerPlus.homeScreen;

                  await WallpaperManagerPlus().setWallpaper(file.path, location);
                },
                icon: const Icon(Icons.home),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.lock_sharp)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
