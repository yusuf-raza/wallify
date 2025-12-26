import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/favourite/widgets/favourite_app_bar_overlay.dart';
import 'package:wallify/presentation/favourite/widgets/favourite_empty_state.dart';
import 'package:wallify/presentation/favourite/widgets/favourite_manage_mode_view.dart';
import 'package:wallify/presentation/favourite/widgets/favourite_slider_view.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 66.h;
    final double topInset = MediaQuery.of(context).padding.top;
    final double topPadding = appBarHeight + topInset;

    return Scaffold(
      body: Consumer2<ThemeViewModel, FavouriteVM>(
        builder:
            (
              BuildContext context,
              ThemeViewModel themeViewModel,
              FavouriteVM favouriteViewModel,
              Widget? child,
            ) {
              Widget buildContentWithAppBar({required Widget content, bool padTop = true}) {
                return Stack(
                  children: <Widget>[
                    padTop
                        ? Padding(
                            padding: EdgeInsets.only(top: topPadding),
                            child: content,
                          )
                        : content,
                    FavouriteAppBarOverlay(
                      appBarHeight: appBarHeight,
                      themeViewModel: themeViewModel,
                      favouriteViewModel: favouriteViewModel,
                    ),
                  ],
                );
              }

              if (favouriteViewModel.isLoading) {
                return buildContentWithAppBar(
                  content: const Center(child: CustomProgressIndicator.CustomProgressIndicator()),
                  padTop: false,
                );
              }

              if (favouriteViewModel.favouriteWallpapers.isEmpty) {
                return buildContentWithAppBar(
                  content: FavouriteEmptyState(
                    onBrowse: () => Provider.of<HomeVM>(context, listen: false).changeIndex(0),
                  ),
                );
              }

              if (favouriteViewModel.isManageMode) {
                return buildContentWithAppBar(
                  content: FavouriteManageModeView(
                    wallpapers: favouriteViewModel.favouriteWallpapers,
                    isSelected: favouriteViewModel.isSelected,
                    onToggleSelection: favouriteViewModel.toggleSelection,
                    canManageSelection: favouriteViewModel.canManageSelection,
                    removeSelectionLabel: favouriteViewModel.removeSelectionLabel,
                    isDownloading: favouriteViewModel.isDownloading,
                    downloadProgressLabel: favouriteViewModel.downloadProgressLabel,
                    downloadSelectionLabel: favouriteViewModel.downloadSelectionLabel,
                    onRemoveSelected: favouriteViewModel.removeSelectedFavourites,
                    onDownloadSelected: favouriteViewModel.downloadSelectedWallpapers,
                    onCancel: favouriteViewModel.toggleManageMode,
                  ),
                );
              }

              final double carouselHeight = MediaQuery.of(context).size.height * 0.7;
              final String backgroundUrl = favouriteViewModel.currentBackgroundUrl;
              final Widget backgroundImage = backgroundUrl.isEmpty
                  ? const SizedBox.expand()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        key: ValueKey<String>(backgroundUrl),
                        imageUrl: backgroundUrl,
                        fit: BoxFit.cover,
                      ),
                    );

              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeIn,
                      child: backgroundImage,
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: FavouriteSliderView(
                        wallpapers: favouriteViewModel.favouriteWallpapers,
                        carouselHeight: carouselHeight,
                        currentIndex: favouriteViewModel.currentIndex,
                        autoPlay: favouriteViewModel.autoPlay,
                        isDownloading: favouriteViewModel.isDownloading,
                        isMultiDownloadInProgress: favouriteViewModel.isMultiDownloadInProgress,
                        downloadProgressLabel: favouriteViewModel.downloadProgressLabel,
                        downloadActionLabel: favouriteViewModel.downloadActionLabel,
                        onOpenDetail: (WallhavenWallpaper wallpaper) => context.push(
                          AppRouter.wallpaperDetailNew,
                          extra: <String, Object?>{'wallpaper': wallpaper},
                        ),
                        isFavourite: favouriteViewModel.isFavourite,
                        onToggleFavourite: favouriteViewModel.addOrRemoveFavourite,
                        onDownloadSingle: favouriteViewModel.downloadSingleWallpaper,
                        onPageChanged: favouriteViewModel.setCurrentIndex,
                        onToggleAutoplay: favouriteViewModel.toggleAutoplay,
                      ),
                    ),
                  ),
                  FavouriteAppBarOverlay(
                    appBarHeight: appBarHeight,
                    themeViewModel: themeViewModel,
                    favouriteViewModel: favouriteViewModel,
                  ),
                ],
              );
            },
      ),
    );
  }
}
