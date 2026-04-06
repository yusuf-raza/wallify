import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/detail_action_button.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/detail_info_row.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/set_wallpaper_bottom_sheet.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.wallpaper, this.loggerService, this.heroTag});

  final WallhavenWallpaper wallpaper;
  final LoggerService? loggerService;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = fromHex(wallpaper.colors![0]);
    final Color secondaryColor = fromHex(wallpaper.colors![1]);
    final bool isDesktop = context.isDesktop;

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<WallpaperDetailVM>(create: (_) => WallpaperDetailVM()),
      ],
      child: Consumer2<WallpaperDetailVM, FavouriteVM>(
        builder:
            (BuildContext context, WallpaperDetailVM viewModel, FavouriteVM favouriteViewModel, _) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton.filled(
                    //color: AppColors.white,
                    style: IconButton.styleFrom(backgroundColor: primaryColor),

                    onPressed: () => context.pop(),
                    icon: Icon(Icons.keyboard_backspace, color: secondaryColor),
                  ),
                  backgroundColor: secondaryColor,
                ),
                backgroundColor: secondaryColor,
                body: ResponsiveContent(
                  padding: EdgeInsets.fromLTRB(
                    context.contentHorizontalPadding,
                    isDesktop ? 28 : 0,
                    context.contentHorizontalPadding,
                    24,
                  ),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 6, child: _buildImagePreview(context, secondaryColor, primaryColor)),
                            const SizedBox(width: 32),
                            SizedBox(
                              width: 360,
                              child: _buildInfoPanel(
                                context,
                                viewModel,
                                favouriteViewModel,
                                primaryColor,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            _buildImagePreview(context, secondaryColor, primaryColor),
                            SizedBox(height: 16.h),
                            _buildInfoPanel(
                              context,
                              viewModel,
                              favouriteViewModel,
                              primaryColor,
                            ),
                          ],
                        ),
                ),
              );
            },
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, Color secondaryColor, Color primaryColor) {
    final bool isDesktop = context.isDesktop;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRouter.fullScreen,
          extra: <String, Object?>{'wallpaper': wallpaper, 'heroTag': heroTag},
        );
      },
      child: Hero(
        tag: heroTag ?? wallpaper.path ?? wallpaper.id ?? 'wallpaper-hero',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 28 : 20.r),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            height: isDesktop ? MediaQuery.sizeOf(context).height * 0.72 : 300.h,
            width: double.infinity,
            imageUrl: wallpaper.thumbs!.large!,
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url) => ClipRRect(
              borderRadius: BorderRadius.circular(isDesktop ? 28 : 20.r),
              clipBehavior: Clip.antiAlias,
              child: Shimmer.fromColors(
                baseColor: secondaryColor,
                highlightColor: primaryColor,
                child: Container(
                  height: isDesktop ? MediaQuery.sizeOf(context).height * 0.72 : 300.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(isDesktop ? 28 : 20.r),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(
    BuildContext context,
    WallpaperDetailVM viewModel,
    FavouriteVM favouriteViewModel,
    Color primaryColor,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(context.isDesktop ? 0.12 : 0),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.isDesktop ? 24 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
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
            ),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: <Widget>[
                DetailActionButton(
                  icon: Icons.save_alt,
                  label: AppStrings.save,
                  color: primaryColor,
                  onTap: () => viewModel.saveWallpaper(wallpaper.path!),
                  isLoading: viewModel.isDownloading,
                ),
                if (viewModel.canSetWallpaper)
                  DetailActionButton(
                    icon: Icons.image_outlined,
                    label: AppStrings.set,
                    color: primaryColor,
                    isLoading: viewModel.isSettingWallpaper,
                    onTap: () {
                      if (!viewModel.canSetWallpaper) {
                        viewModel.showWallpaperSettingUnavailableMessage();
                        return;
                      }
                      showSetWallpaperBottomSheet(
                        context,
                        viewModel,
                        wallpaper.path!,
                      );
                    },
                  ),
              ],
            ),
            SizedBox(height: context.isDesktop ? 24 : 10.h),
            Column(
              children: <Widget>[
                DetailInfoRow(
                  icon: Icons.category,
                  text: wallpaper.category!,
                  color: primaryColor,
                ),
                SizedBox(height: context.isDesktop ? 12 : 3.h),
                DetailInfoRow(
                  icon: Icons.photo_size_select_actual_outlined,
                  text: '${wallpaper.dimensionX} x ${wallpaper.dimensionY}',
                  color: primaryColor,
                ),
                SizedBox(height: context.isDesktop ? 12 : 3.h),
                DetailInfoRow(
                  icon: Icons.folder,
                  text: '${(wallpaper.fileSize! / (1024 * 1024)).toStringAsFixed(2)} MB',
                  color: primaryColor,
                ),
                SizedBox(height: context.isDesktop ? 12 : 3.h),
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
  }
}
