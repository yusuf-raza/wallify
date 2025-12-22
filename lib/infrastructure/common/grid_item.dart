import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.wallpaper, required this.onTap});

  final WallhavenWallpaper wallpaper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Calculate the aspect ratio from the wallpaper's dimensions.
    // This helps the grid item maintain its shape even before the image loads.
    final double aspectRatio = (wallpaper.dimensionX ?? 1) / (wallpaper.dimensionY ?? 1);
    final List<String> colors = wallpaper.colors ?? <String>[];
    final Color primaryColor = colors.isNotEmpty ? fromHex(colors.first) : AppColors.grey;
    final Color secondaryColor = colors.length > 1 ? fromHex(colors[1]) : AppColors.black;
    final String imageUrl = wallpaper.thumbs?.large ?? wallpaper.path ?? '';
    final bool hasColors = colors.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: hasColors
              ? null
              : const LinearGradient(
                  colors: <Color>[
                    AppColors.orange,
                    AppColors.pink,
                    AppColors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (
                BuildContext context,
                String url,
                DownloadProgress progress,
              ) =>
                  Shimmer.fromColors(
                    baseColor: primaryColor,
                    highlightColor: secondaryColor,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              errorWidget: (BuildContext context, String url, Object error) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
      ),
    );
  }
}
