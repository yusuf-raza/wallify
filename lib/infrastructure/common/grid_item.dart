import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.wallpaper, required this.onTap});

  final WallhavenWallpaper wallpaper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: wallpaper.thumbs?.large ?? '',
          fit: BoxFit.cover,
          progressIndicatorBuilder:
              (BuildContext context, String url, DownloadProgress downloadProgress) {
                return Center(
                  child: LinearProgressIndicator(
                    value: downloadProgress.progress,
                    color: Color(int.parse('0xFF${wallpaper!.colors![0].replaceFirst('#', '')}')),
                  ),
                );
              },
          errorWidget: (BuildContext context, String url, Object error) =>
              const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}
