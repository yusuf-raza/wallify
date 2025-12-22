import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/full_screen_image.screen.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/detail_action_button.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/detail_info_row.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/set_wallpaper_bottom_sheet.dart';

class WallpaperDetailScreenNew extends StatelessWidget {
  const WallpaperDetailScreenNew({
    super.key,
    required this.wallpaper,
    this.loggerService,
    this.heroTag,
  });

  final WallhavenWallpaper wallpaper;
  final LoggerService? loggerService;
  final String? heroTag;

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
                  leading: IconButton.filled(
                    //color: AppColors.white,
                    style: IconButton.styleFrom(backgroundColor: primaryColor),

                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.keyboard_backspace, color: AppColors.white),
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
                              builder: (BuildContext context) => FullScreenImageScreen(
                                wallpaper: wallpaper,
                                heroTag: heroTag,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: heroTag ?? wallpaper.path ?? wallpaper.id ?? 'wallpaper-hero',
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
                              DetailActionButton(
                                icon: Icons.save_alt,
                                label: AppStrings.save,
                                color: primaryColor,
                                onTap: () => viewModel.saveWallpaper(wallpaper.path!),
                                isLoading: viewModel.isDownloading,
                              ),
                              DetailActionButton(
                                icon: Icons.image_outlined,
                                label: AppStrings.set,
                                color: primaryColor,
                                isLoading: viewModel.isSettingWallpaper,
                                onTap: () => showSetWallpaperBottomSheet(
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
                          DetailInfoRow(
                            icon: Icons.category,
                            text: wallpaper.category!,
                            color: primaryColor,
                          ),
                          DetailInfoRow(
                            icon: Icons.photo_size_select_actual_outlined,
                            text: '${wallpaper.dimensionX} x ${wallpaper.dimensionY}',
                            color: primaryColor,
                          ),
                          DetailInfoRow(
                            icon: Icons.folder,
                            text: '${(wallpaper.fileSize! / (1024 * 1024)).toStringAsFixed(2)} MB',
                            color: primaryColor,
                          ),
                          DetailInfoRow(
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
}
