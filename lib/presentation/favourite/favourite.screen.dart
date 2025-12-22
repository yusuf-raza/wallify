import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/favourite/widgets/quick_action_button.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(66.h),
        child: Consumer2<ThemeViewModel, FavouriteViewModel>(
          builder:
              (
                BuildContext context,
                ThemeViewModel themeController,
                FavouriteViewModel favouriteViewModel,
                Widget? child,
              ) {
                return AppBar(
                  centerTitle: true,
                  title: Text(
                    AppStrings.favourite,
                    style: AppTextStyles.screenTitle,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.dark_mode, size: 25),
                      onPressed: themeController.toggleTheme,
                    ),
                    IconButton(
                      icon: Icon(favouriteViewModel.isManageMode ? Icons.done : Icons.tune),
                      onPressed: favouriteViewModel.toggleManageMode,
                    ),
                  ],
                );
              },
        ),
      ),
      body: Consumer<FavouriteViewModel>(
        builder: (BuildContext context, FavouriteViewModel favouriteViewModel, Widget? child) {
          if (favouriteViewModel.isLoading) {
            return const Center(child: CustomProgressIndicator.CustomProgressIndicator());
          }
          if (favouriteViewModel.favouriteWallpapers.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite_border, size: 90.px, color: AppColors.grey),
                    SizedBox(height: 12.h),
                    Text(
                      AppStrings.noFavouriteWallpapers,
                      style: AppTextStyles.emptyStateTitle,
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () =>
                          Provider.of<HomeViewModel>(context, listen: false).changeIndex(0),
                      child: Text(
                        AppStrings.browseWallpapers,
                        style: AppTextStyles.emptyStateTitle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (favouriteViewModel.isManageMode) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                    ),
                    itemCount: favouriteViewModel.favouriteWallpapers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final WallhavenWallpaper wallpaper =
                          favouriteViewModel.favouriteWallpapers[index];
                      final bool isSelected = favouriteViewModel.isSelected(wallpaper);
                      return GestureDetector(
                        onTap: () => favouriteViewModel.toggleSelection(wallpaper),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: wallpaper.thumbs?.small ?? wallpaper.path ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.blackWithOpacity,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? AppColors.green : AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.blackWithOpacity,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (favouriteViewModel.isDownloading)
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Text(
                            AppStrings.downloadProgress(
                              favouriteViewModel.downloadCompleted,
                              favouriteViewModel.downloadTotal,
                            ),
                            style: AppTextStyles.labelSmallBold,
                          ),
                        ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.w,
                        runSpacing: 4.h,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed:
                                favouriteViewModel.selectedCount == 0 ||
                                    favouriteViewModel.isDownloading
                                ? null
                                : favouriteViewModel.removeSelectedFavourites,
                            icon: const Icon(Icons.delete),
                            label: Text(AppStrings.removeCount(favouriteViewModel.selectedCount)),
                          ),
                          TextButton.icon(
                            onPressed:
                                favouriteViewModel.selectedCount == 0 ||
                                    favouriteViewModel.isDownloading
                                ? null
                                : favouriteViewModel.downloadSelectedWallpapers,
                            icon: favouriteViewModel.isDownloading
                                ? SizedBox(
                                    width: 16.r,
                                    height: 16.r,
                                    child: const CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.download),
                            label: Text(
                              favouriteViewModel.isDownloading
                                  ? AppStrings.downloadingEllipsis
                                  : AppStrings.downloadCount(favouriteViewModel.selectedCount),
                            ),
                          ),
                          TextButton(
                            onPressed: favouriteViewModel.toggleManageMode,
                            child: const Text(AppStrings.cancel),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final int total = favouriteViewModel.favouriteWallpapers.length;
          final double carouselHeight = MediaQuery.of(context).size.height * 0.7;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: carouselHeight,
                  child: CarouselSlider.builder(
                    itemCount: total,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      final WallhavenWallpaper wallpaper =
                          favouriteViewModel.favouriteWallpapers[index];
                      final String title = wallpaper.id ?? AppStrings.wallpaperIndex(index + 1);
                      final String subtitle =
                          wallpaper.resolution ?? AppStrings.resolutionUnavailable;
                      return GestureDetector(
                        onTap: () => context.push(
                          AppRouter.wallpaperDetailNew,
                          extra: <String, Object?>{'wallpaper': wallpaper},
                        ),
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
                                  color: AppColors.blackWithOpacity,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.r),
                                    bottomRight: Radius.circular(20.r),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                            Text(
                                              title,
                                              style: AppTextStyles.cardTitle.copyWith(
                                                color: AppColors.white,
                                              ),
                                            ),
                                            Text(
                                              subtitle,
                                              style: AppTextStyles.cardSubtitle.copyWith(
                                                color: AppColors.white,
                                              ),
                                            ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            favouriteViewModel.addOrRemoveFavourite(wallpaper);
                                          },
                                          icon: Icon(
                                            favouriteViewModel.isFavourite(wallpaper)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 8.w,
                                      runSpacing: 4.h,
                                      children: <Widget>[
                                        QuickActionButton(
                                          icon: Icons.wallpaper,
                                          label: AppStrings.set,
                                          onPressed: () => context.push(
                                            AppRouter.wallpaperDetailNew,
                                            extra: <String, Object?>{'wallpaper': wallpaper},
                                          ),
                                        ),
                                        QuickActionButton(
                                        icon: Icons.download,
                                        label: favouriteViewModel.isDownloading
                                            ? AppStrings.downloadingEllipsis
                                            : AppStrings.download,
                                        isBusy: favouriteViewModel.isDownloading,
                                          onPressed: favouriteViewModel.isDownloading
                                              ? null
                                              : () => favouriteViewModel.downloadSingleWallpaper(
                                                  wallpaper,
                                                ),
                                        ),
                                      ],
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
                      autoPlay: favouriteViewModel.autoPlay,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      onPageChanged: (int index, CarouselPageChangedReason reason) {
                        favouriteViewModel.setCurrentIndex(index);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                if (favouriteViewModel.isDownloading && favouriteViewModel.downloadTotal > 1)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      AppStrings.downloadProgress(
                        favouriteViewModel.downloadCompleted,
                        favouriteViewModel.downloadTotal,
                      ),
                      style: AppTextStyles.labelSmallBold,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (total <= 8)
                      ...List<Widget>.generate(total, (int index) {
                        final bool isActive = index == favouriteViewModel.currentIndex;
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
                      '${favouriteViewModel.currentIndex + 1} / $total',
                      style: AppTextStyles.bodyMedium,
                    ),
                    SizedBox(width: 12.w),
                    IconButton(
                      onPressed: () {
                        favouriteViewModel.toggleAutoplay();
                      },
                      icon: Icon(
                        favouriteViewModel.autoPlay ? Icons.pause_circle : Icons.play_circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
