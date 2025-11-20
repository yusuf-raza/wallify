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
        child: Image.network(
          wallpaper.thumbs?.original ?? '',
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
              const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}
