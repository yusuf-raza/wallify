import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class FavouriteSliderView extends StatelessWidget {
  const FavouriteSliderView({
    super.key,
    required this.wallpapers,
    required this.carouselHeight,
    required this.currentIndex,
    required this.autoPlay,
    required this.isDownloading,
    required this.isMultiDownloadInProgress,
    required this.downloadProgressLabel,
    required this.downloadActionLabel,
    required this.onOpenDetail,
    required this.isFavourite,
    required this.onToggleFavourite,
    required this.onDownloadSingle,
    required this.onPageChanged,
    required this.onToggleAutoplay,
  });

  final List<WallhavenWallpaper> wallpapers;
  final double carouselHeight;
  final int currentIndex;
  final bool autoPlay;
  final bool isDownloading;
  final bool isMultiDownloadInProgress;
  final String downloadProgressLabel;
  final String downloadActionLabel;
  final void Function(WallhavenWallpaper wallpaper) onOpenDetail;
  final bool Function(WallhavenWallpaper wallpaper) isFavourite;
  final void Function(WallhavenWallpaper wallpaper) onToggleFavourite;
  final void Function(WallhavenWallpaper wallpaper) onDownloadSingle;
  final void Function(int index) onPageChanged;
  final VoidCallback onToggleAutoplay;

  @override
  Widget build(BuildContext context) {
    final int total = wallpapers.length;
    return Column(
      children: <Widget>[
        SizedBox(
          height: carouselHeight,
          child: CarouselSlider.builder(
            itemCount: total,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final WallhavenWallpaper wallpaper = wallpapers[index];
              return GestureDetector(
                onTap: () => onOpenDetail(wallpaper),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: CachedNetworkImage(
                        imageUrl: wallpaper.path ?? '',
                        fit: BoxFit.cover,
                        width: 1000.0,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: .end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => onToggleFavourite(wallpaper),
                              icon: Icon(
                                isFavourite(wallpaper) ? Icons.favorite : Icons.favorite_border,
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              height: carouselHeight,
              aspectRatio: 14 / 9,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: autoPlay,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                onPageChanged(index);
              },
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if (isMultiDownloadInProgress)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(downloadProgressLabel, style: AppTextStyles.labelSmallBold),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (total <= 8)
              ...List<Widget>.generate(total, (int index) {
                final bool isActive = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  height: 8.r,
                  width: isActive ? 18.r : 8.r,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primaryColor : AppColors.grey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                );
              })
            else
              Text(
                '${currentIndex + 1} / $total',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
              ),
            SizedBox(width: 12.w),
            IconButton(
              onPressed: onToggleAutoplay,
              icon: Icon(autoPlay ? Icons.pause_circle : Icons.play_circle),
            ),
          ],
        ),
      ],
    );
  }
}
