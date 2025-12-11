import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/full_screen_image.screen.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperDetailScreenNew extends StatelessWidget {
  const WallpaperDetailScreenNew({super.key, required this.wallpaper, this.loggerService});

  final WallhavenWallpaper wallpaper;
  final LoggerService? loggerService;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = fromHex(wallpaper.colors![0]);
    final Color secondaryColor = fromHex(wallpaper.colors![1]);

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<WallpaperDetailViewModel>(create: (_) => WallpaperDetailViewModel()),
      ],
      child: Consumer2<WallpaperDetailViewModel, FavouriteViewModel>(
        builder:
            (
              BuildContext context,
              WallpaperDetailViewModel viewModel,
              FavouriteViewModel favouriteViewModel,
              _,
            ) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.keyboard_backspace, color: primaryColor),
                  ),
                  backgroundColor: secondaryColor,
                ),
                backgroundColor: secondaryColor,
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  FullScreenImageScreen(wallpaper: wallpaper),
                            ),
                          );
                        },
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
                      ),

                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: <Widget>[
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  favouriteViewModel.addOrRemoveFavourite(wallpaper);
                                },
                                icon: Icon(
                                  favouriteViewModel.isFavourite(wallpaper)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: <Widget>[
                              _buildButton(
                                icon: Icons.save_alt,
                                label: AppStrings.save,
                                color: primaryColor,
                                onTap: () => viewModel.saveWallpaper(wallpaper.path!),
                                isDownloading: viewModel.isDownloading,
                              ),
                              _buildButton(
                                icon: Icons.image_outlined,
                                label: AppStrings.set,
                                color: primaryColor,
                                isDownloading: viewModel.isSettingWallpaper,
                                onTap: () => _showSetWallpaperBottomSheet(
                                  context,
                                  viewModel,
                                  wallpaper.path!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        spacing: 3.h,
                        children: <Widget>[
                          _buildInfoRow(
                            icon: Icons.category,
                            text: wallpaper.category!,
                            color: primaryColor,
                          ),
                          _buildInfoRow(
                            icon: Icons.photo_size_select_actual_outlined,
                            text: '${wallpaper.dimensionX} x ${wallpaper.dimensionY}',
                            color: primaryColor,
                          ),
                          _buildInfoRow(
                            icon: Icons.folder,
                            text: '${(wallpaper.fileSize! / (1024 * 1024)).toStringAsFixed(2)} MB',
                            color: primaryColor,
                          ),
                          _buildInfoRow(
                            icon: Icons.privacy_tip_outlined,
                            text: wallpaper.purity!,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
      ),
    );
  }

  void _showSetWallpaperBottomSheet(
    BuildContext context,
    WallpaperDetailViewModel viewModel,
    String imageUrl,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.home),
                title: Text(AppStrings.setAsHomeScreen),
                onTap: () {
                  viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.homeScreen);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(AppStrings.setAsLockScreen),
                onTap: () {
                  viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.lockScreen);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: Text(AppStrings.setAsBoth),
                onTap: () {
                  viewModel.setWallpaper(imageUrl, WallpaperManagerFlutter.bothScreens);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDownloading = false,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(30.r),
        child: Container(
          height: 50,
          width: 120,
          // padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: .circular(30.r),
            border: Border.all(color: color, width: 2.w),
          ),
          child: isDownloading
              ? const Center(
                  child: CustomProgressIndicator.CustomProgressIndicator(color: AppColors.white),
                )
              : Row(
                  mainAxisAlignment: .center,
                  spacing: 3.w,
                  children: <Widget>[
                    Icon(icon, color: color),
                    Text(label, style: TextStyle(color: color)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text, required Color color}) {
    return Row(
      spacing: 3.w,
      children: <Widget>[
        Icon(icon, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
