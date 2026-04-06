import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
              final bool isDesktop = context.isDesktop;

              if (isDesktop) {
                return _DesktopFavouriteView(
                  themeViewModel: themeViewModel,
                  favouriteViewModel: favouriteViewModel,
                );
              }

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

class _DesktopFavouriteView extends StatelessWidget {
  const _DesktopFavouriteView({
    required this.themeViewModel,
    required this.favouriteViewModel,
  });

  final ThemeViewModel themeViewModel;
  final FavouriteVM favouriteViewModel;

  @override
  Widget build(BuildContext context) {
    final WallhavenWallpaper? currentWallpaper = favouriteViewModel.currentWallpaper;

    Widget buildHeader() {
      return ResponsiveContent(
        padding: EdgeInsets.fromLTRB(
          context.contentHorizontalPadding,
          28,
          context.contentHorizontalPadding,
          16,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppStrings.favourite, style: AppTextStyles.appTitle),
                  Text(
                    '${favouriteViewModel.totalWallpapers} saved wallpapers',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode, size: 25),
              onPressed: themeViewModel.toggleTheme,
            ),
            const SizedBox(width: 8),
            FilledButton.tonalIcon(
              onPressed: favouriteViewModel.toggleManageMode,
              icon: Icon(favouriteViewModel.isManageMode ? Icons.done : Icons.tune),
              label: Text(favouriteViewModel.isManageMode ? 'Done' : 'Manage'),
            ),
          ],
        ),
      );
    }

    if (favouriteViewModel.isLoading) {
      return Column(
        children: <Widget>[
          buildHeader(),
          const Expanded(child: Center(child: CustomProgressIndicator.CustomProgressIndicator())),
        ],
      );
    }

    if (favouriteViewModel.favouriteWallpapers.isEmpty) {
      return Column(
        children: <Widget>[
          buildHeader(),
          Expanded(
            child: FavouriteEmptyState(
              onBrowse: () => Provider.of<HomeVM>(context, listen: false).changeIndex(0),
            ),
          ),
        ],
      );
    }

    if (favouriteViewModel.isManageMode) {
      return Column(
        children: <Widget>[
          buildHeader(),
          Expanded(
            child: ResponsiveContent(
              padding: EdgeInsets.fromLTRB(
                context.contentHorizontalPadding,
                0,
                context.contentHorizontalPadding,
                24,
              ),
              child: FavouriteManageModeView(
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
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        buildHeader(),
        Expanded(
          child: ResponsiveContent(
            padding: EdgeInsets.fromLTRB(
              context.contentHorizontalPadding,
              0,
              context.contentHorizontalPadding,
              24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (currentWallpaper != null)
                          CachedNetworkImage(
                            imageUrl: currentWallpaper.path ?? '',
                            fit: BoxFit.cover,
                          ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.black.withOpacity(0.08),
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        if (currentWallpaper != null)
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${favouriteViewModel.currentIndex + 1} of ${favouriteViewModel.totalWallpapers}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: <Widget>[
                                    FilledButton.icon(
                                      onPressed: () => context.push(
                                        AppRouter.wallpaperDetailNew,
                                        extra: <String, Object?>{'wallpaper': currentWallpaper},
                                      ),
                                      icon: const Icon(Icons.open_in_full),
                                      label: const Text('Open detail'),
                                    ),
                                    FilledButton.tonalIcon(
                                      onPressed: favouriteViewModel.isDownloading
                                          ? null
                                          : () => favouriteViewModel.downloadSingleWallpaper(
                                              currentWallpaper,
                                            ),
                                      icon: favouriteViewModel.isDownloading
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Icon(Icons.download),
                                      label: Text(favouriteViewModel.downloadActionLabel),
                                    ),
                                    FilledButton.tonalIcon(
                                      onPressed: () =>
                                          favouriteViewModel.addOrRemoveFavourite(currentWallpaper),
                                      icon: const Icon(Icons.favorite),
                                      label: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 340,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Gallery', style: AppTextStyles.screenTitle),
                              ),
                              IconButton(
                                onPressed: favouriteViewModel.toggleAutoplay,
                                icon: Icon(
                                  favouriteViewModel.autoPlay
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: favouriteViewModel.favouriteWallpapers.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (BuildContext context, int index) {
                              final WallhavenWallpaper wallpaper =
                                  favouriteViewModel.favouriteWallpapers[index];
                              final bool isActive = index == favouriteViewModel.currentIndex;

                              return InkWell(
                                onTap: () => favouriteViewModel.setCurrentIndex(index),
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isActive
                                        ? AppColors.purple.withOpacity(0.12)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isActive
                                          ? AppColors.purple.withOpacity(0.32)
                                          : Theme.of(context).dividerColor.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: CachedNetworkImage(
                                          imageUrl: wallpaper.thumbs?.small ?? wallpaper.path ?? '',
                                          width: 84,
                                          height: 84,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Wallpaper ${index + 1}',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${wallpaper.dimensionX} x ${wallpaper.dimensionY}',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
