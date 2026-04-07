import 'dart:async';
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
              ThemeViewModel _,
              FavouriteVM favouriteViewModel,
              Widget? child,
            ) {
              final bool isDesktop = context.isDesktop;

              if (isDesktop) {
                return _DesktopFavouriteView(favouriteViewModel: favouriteViewModel);
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
                    favouriteViewModel: favouriteViewModel,
                  ),
                ],
              );
            },
      ),
    );
  }
}

class _DesktopFavouriteView extends StatefulWidget {
  const _DesktopFavouriteView({required this.favouriteViewModel});

  final FavouriteVM favouriteViewModel;

  @override
  State<_DesktopFavouriteView> createState() => _DesktopFavouriteViewState();
}

class _DesktopFavouriteViewState extends State<_DesktopFavouriteView> {
  Timer? _autoplayTimer;

  FavouriteVM get favouriteViewModel => widget.favouriteViewModel;

  @override
  void initState() {
    super.initState();
    favouriteViewModel.addListener(_syncAutoplay);
    _syncAutoplay();
  }

  @override
  void didUpdateWidget(covariant _DesktopFavouriteView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favouriteViewModel != widget.favouriteViewModel) {
      oldWidget.favouriteViewModel.removeListener(_syncAutoplay);
      _autoplayTimer?.cancel();
      widget.favouriteViewModel.addListener(_syncAutoplay);
      _syncAutoplay();
    }
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    favouriteViewModel.removeListener(_syncAutoplay);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WallhavenWallpaper? currentWallpaper = favouriteViewModel.currentWallpaper;

    if (favouriteViewModel.isLoading) {
      return _DesktopFavouriteShell(
        header: _DesktopFavouriteHeader(favouriteViewModel: favouriteViewModel),
        child: const Center(child: CustomProgressIndicator.CustomProgressIndicator()),
      );
    }

    if (favouriteViewModel.favouriteWallpapers.isEmpty) {
      return _DesktopFavouriteShell(
        header: _DesktopFavouriteHeader(favouriteViewModel: favouriteViewModel),
        child: FavouriteEmptyState(
          onBrowse: () => Provider.of<HomeVM>(context, listen: false).changeIndex(0),
        ),
      );
    }

    if (favouriteViewModel.isManageMode) {
      return _DesktopFavouriteShell(
        header: _DesktopFavouriteHeader(favouriteViewModel: favouriteViewModel),
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
      );
    }

    final WallhavenWallpaper wallpaper = currentWallpaper!;
    final String heroTag =
        'desktop-favourite-${wallpaper.id ?? favouriteViewModel.currentIndex}';

    return _DesktopFavouriteShell(
      header: _DesktopFavouriteHeader(favouriteViewModel: favouriteViewModel),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: _DesktopSpotlightCard(
              wallpaper: wallpaper,
              currentIndex: favouriteViewModel.currentIndex + 1,
              totalWallpapers: favouriteViewModel.totalWallpapers,
              isDownloading: favouriteViewModel.isDownloading,
              downloadActionLabel: favouriteViewModel.downloadActionLabel,
              heroTag: heroTag,
              onOpenDetail: () => context.push(
                AppRouter.fullScreen,
                extra: <String, Object?>{
                  'wallpaper': wallpaper,
                  'heroTag': heroTag,
                },
              ),
              onDownload: favouriteViewModel.isDownloading
                  ? null
                  : () => favouriteViewModel.downloadSingleWallpaper(wallpaper),
              onRemove: () => favouriteViewModel.addOrRemoveFavourite(wallpaper),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 380,
            child: _DesktopGalleryPanel(favouriteViewModel: favouriteViewModel),
          ),
        ],
      ),
    );
  }

  void _syncAutoplay() {
    final bool shouldAutoplay =
        favouriteViewModel.autoPlay &&
        !favouriteViewModel.isManageMode &&
        favouriteViewModel.favouriteWallpapers.length > 1;

    if (!shouldAutoplay) {
      _autoplayTimer?.cancel();
      _autoplayTimer = null;
      return;
    }

    if (_autoplayTimer != null && _autoplayTimer!.isActive) {
      return;
    }

    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final int total = favouriteViewModel.favouriteWallpapers.length;
      if (total <= 1) {
        return;
      }
      final int nextIndex = (favouriteViewModel.currentIndex + 1) % total;
      favouriteViewModel.setCurrentIndex(nextIndex);
    });
  }
}

class _DesktopFavouriteShell extends StatelessWidget {
  const _DesktopFavouriteShell({required this.header, required this.child});

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).colorScheme.surface.withOpacity(0.96),
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.72),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            header,
            Expanded(
              child: ResponsiveContent(
                padding: EdgeInsets.fromLTRB(
                  context.contentHorizontalPadding,
                  0,
                  context.contentHorizontalPadding,
                  24,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DesktopFavouriteHeader extends StatelessWidget {
  const _DesktopFavouriteHeader({required this.favouriteViewModel});

  final FavouriteVM favouriteViewModel;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      padding: EdgeInsets.fromLTRB(
        context.contentHorizontalPadding,
        16,
        context.contentHorizontalPadding,
        18,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.purple.withOpacity(0.12),
              AppColors.orange.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.08)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppStrings.favourite, style: AppTextStyles.appTitle),
                  const SizedBox(height: 6),
                  Text(
                    'A curated desktop gallery for your saved wallpapers.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: <Widget>[
                _DesktopHeaderChip(
                  icon: Icons.photo_library_outlined,
                  label: '${favouriteViewModel.totalWallpapers} saved',
                ),
                _DesktopHeaderChip(
                  icon: favouriteViewModel.autoPlay ? Icons.pause_circle : Icons.play_circle,
                  label: favouriteViewModel.autoPlay ? 'Autoplay on' : 'Autoplay off',
                  onTap: favouriteViewModel.toggleAutoplay,
                ),
                FilledButton.tonalIcon(
                  onPressed: favouriteViewModel.toggleManageMode,
                  icon: Icon(favouriteViewModel.isManageMode ? Icons.done : Icons.tune),
                  label: Text(favouriteViewModel.isManageMode ? 'Done' : 'Manage'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class _DesktopHeaderChip extends StatelessWidget {
  const _DesktopHeaderChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: content,
    );
  }
}

class _DesktopSpotlightCard extends StatelessWidget {
  const _DesktopSpotlightCard({
    required this.wallpaper,
    required this.currentIndex,
    required this.totalWallpapers,
    required this.isDownloading,
    required this.downloadActionLabel,
    required this.heroTag,
    required this.onOpenDetail,
    required this.onDownload,
    required this.onRemove,
  });

  final WallhavenWallpaper wallpaper;
  final int currentIndex;
  final int totalWallpapers;
  final bool isDownloading;
  final String downloadActionLabel;
  final String heroTag;
  final VoidCallback onOpenDetail;
  final VoidCallback? onDownload;
  final VoidCallback onRemove;

  String get _resolutionLabel =>
      wallpaper.resolution ?? '${wallpaper.dimensionX ?? 0} x ${wallpaper.dimensionY ?? 0}';

  String get _fileSizeLabel {
    final int? fileSize = wallpaper.fileSize;
    if (fileSize == null) {
      return 'Unknown size';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: CachedNetworkImage(
                  key: ValueKey<String>(wallpaper.path ?? wallpaper.id ?? '$currentIndex'),
                  imageUrl: wallpaper.path ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black.withOpacity(0.08),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.78),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                top: 24,
                child: _DesktopOverlayTag(
                  icon: Icons.layers_outlined,
                  label: '$currentIndex of $totalWallpapers',
                ),
              ),
              Positioned(
                left: 28,
                right: 28,
                bottom: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Wallpaper $currentIndex',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      wallpaper.category ?? 'Saved wallpaper',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.86)),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _DesktopMetaPill(label: _resolutionLabel),
                        _DesktopMetaPill(label: _fileSizeLabel),
                        if ((wallpaper.ratio ?? '').isNotEmpty)
                          _DesktopMetaPill(label: 'Ratio ${wallpaper.ratio}'),
                        if ((wallpaper.fileType ?? '').isNotEmpty)
                          _DesktopMetaPill(label: (wallpaper.fileType ?? '').toUpperCase()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: onOpenDetail,
                          icon: const Icon(Icons.open_in_full),
                          label: const Text('View full screen'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: onDownload,
                          icon: isDownloading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.download),
                          label: Text(downloadActionLabel),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: onRemove,
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
    );
  }
}

class _DesktopGalleryPanel extends StatelessWidget {
  const _DesktopGalleryPanel({required this.favouriteViewModel});

  final FavouriteVM favouriteViewModel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Gallery', style: AppTextStyles.screenTitle),
                const SizedBox(height: 6),
                Text(
                  'Browse, preview, and jump between your saved collection.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              itemCount: favouriteViewModel.favouriteWallpapers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                final WallhavenWallpaper wallpaper = favouriteViewModel.favouriteWallpapers[index];
                final bool isActive = index == favouriteViewModel.currentIndex;
                return _DesktopGalleryTile(
                  wallpaper: wallpaper,
                  index: index,
                  isActive: isActive,
                  onTap: () => favouriteViewModel.setCurrentIndex(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopGalleryTile extends StatelessWidget {
  const _DesktopGalleryTile({
    required this.wallpaper,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  final WallhavenWallpaper wallpaper;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  String get _resolutionLabel =>
      wallpaper.resolution ?? '${wallpaper.dimensionX ?? 0} x ${wallpaper.dimensionY ?? 0}';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: isActive
              ? LinearGradient(
                  colors: <Color>[
                    AppColors.purple.withOpacity(0.14),
                    AppColors.orange.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isActive
                ? AppColors.purple.withOpacity(0.24)
                : Theme.of(context).dividerColor.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: wallpaper.thumbs?.small ?? wallpaper.path ?? '',
                width: 96,
                height: 78,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    wallpaper.category ?? 'Saved wallpaper',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _DesktopMiniPill(label: _resolutionLabel),
                      if ((wallpaper.ratio ?? '').isNotEmpty)
                        _DesktopMiniPill(label: wallpaper.ratio!),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isActive ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isActive
                  ? AppColors.purple
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopOverlayTag extends StatelessWidget {
  const _DesktopOverlayTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopMetaPill extends StatelessWidget {
  const _DesktopMetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _DesktopMiniPill extends StatelessWidget {
  const _DesktopMiniPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
