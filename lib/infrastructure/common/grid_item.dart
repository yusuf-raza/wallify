import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';

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
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
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
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CachedNetworkImage(
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<FavouriteVM>(
                    builder:
                        (
                          BuildContext context,
                          FavouriteVM favouriteViewModel,
                          Widget? child,
                        ) => Material(
                          color: Colors.black.withOpacity(0.28),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => favouriteViewModel.addOrRemoveFavourite(wallpaper),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                favouriteViewModel.isFavourite(wallpaper)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
