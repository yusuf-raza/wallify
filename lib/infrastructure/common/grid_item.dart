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
    final Color primaryColor = fromHex(wallpaper.colors![0]);
    final Color secondaryColor = fromHex(wallpaper.colors![1]);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: .circular(20)),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: CachedNetworkImage(
            imageUrl: wallpaper.thumbs?.large ?? '',
            fit: BoxFit.cover,
            progressIndicatorBuilder:
                (BuildContext context, String url, DownloadProgress progress) => Shimmer.fromColors(
                  baseColor: primaryColor,
                  highlightColor: secondaryColor,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        // borderRadius: .circular(20),
                      ),
                    ),
                  ),
                ),

            //  {
            //   return Center(
            //     child: CustomProgressIndicator.CustomProgressIndicator(
            //       color: Color(int.parse('0xFF${wallpaper.colors![0].replaceFirst('#', '')}')),
            //     ),
            //   );
            // },
            errorWidget: (BuildContext context, String url, Object error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }
}
