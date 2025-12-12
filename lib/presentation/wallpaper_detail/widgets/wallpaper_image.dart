import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:shimmer/shimmer.dart';

class WallpaperImage extends StatelessWidget {
  const WallpaperImage({
    super.key,
    required this.wallpaper,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
  });

  final WallhavenWallpaper wallpaper;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: wallpaper.path!,
        child: CachedNetworkImage(
          height: 300.h,
          width: 300.w,
          imageUrl: wallpaper.thumbs!.large!,
          fit: BoxFit.cover,
          placeholder: (BuildContext context, String url) => Shimmer.fromColors(
            baseColor: secondaryColor,
            highlightColor: primaryColor,
            child: Container(
              height: 300.h,
              decoration: const BoxDecoration(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
