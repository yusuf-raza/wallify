import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.wallpaper, required this.onTap});

  final WallhavenWallpaper wallpaper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Calculate the aspect ratio from the wallpaper's dimensions.
    // This helps the grid item maintain its shape even before the image loads.
    final double aspectRatio = (wallpaper.dimensionX ?? 1) / (wallpaper.dimensionY ?? 1);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: CachedNetworkImage(
            imageUrl: wallpaper.thumbs?.large ?? '',
            fit: BoxFit.cover,
            progressIndicatorBuilder:
                (BuildContext context, String url, DownloadProgress downloadProgress) {
                  return Center(
                    child: CustomProgressIndicator.CustomProgressIndicator(
                      color: Color(int.parse('0xFF${wallpaper.colors![0].replaceFirst('#', '')}')),
                    ),
                  );
                },
            errorWidget: (BuildContext context, String url, Object error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }
}
