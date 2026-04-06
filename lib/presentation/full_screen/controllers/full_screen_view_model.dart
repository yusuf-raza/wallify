import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/widgets/set_wallpaper_bottom_sheet.dart';

class FullScreenVM extends ChangeNotifier {
  FullScreenVM({
    required this.wallpaper,
    required this.detailViewModel,
    required this.favouriteViewModel,
    this.heroTag,
  }) {
    detailViewModel.addListener(_relay);
    favouriteViewModel.addListener(_relay);
  }

  final WallhavenWallpaper wallpaper;
  final WallpaperDetailVM detailViewModel;
  final FavouriteVM favouriteViewModel;
  final String? heroTag;

  final TransformationController transformationController = TransformationController();
  final GlobalKey imageKey = GlobalKey();
  final ValueNotifier<bool> useHiRes = ValueNotifier<bool>(false);

  AnimationController? _animationController;
  Animation<Matrix4>? _zoomAnimation;

  bool get isDownloading => detailViewModel.isDownloading;
  bool get isSettingWallpaper => detailViewModel.isSettingWallpaper;
  bool get isFavourite => favouriteViewModel.isFavourite(wallpaper);
  bool get canSetWallpaper => detailViewModel.canSetWallpaper;

  // Initializes animations and zoom tracking with a ticker provider.
  void init(TickerProvider vsync) {
    if (_animationController != null) return;
    _animationController =
        AnimationController(vsync: vsync, duration: const Duration(milliseconds: 250))
          ..addListener(() {
            if (_zoomAnimation != null) {
              transformationController.value = _zoomAnimation!.value;
            }
          });
    transformationController.addListener(_handleTransformChange);
  }

  // Resets zoom state when a pinch interaction ends.
  void handleInteractionEnd(ScaleEndDetails details) {
    final double scale = transformationController.value.getMaxScaleOnAxis();
    if (scale <= 1.02) {
      _animateTo(Matrix4.identity());
      useHiRes.value = false;
    }
  }

  // Saves the current wallpaper.
  void saveWallpaper() {
    detailViewModel.saveWallpaper(wallpaper.path!);
  }

  // Opens the set-wallpaper sheet.
  void setWallpaper(BuildContext context) {
    if (!detailViewModel.canSetWallpaper) {
      detailViewModel.showWallpaperSettingUnavailableMessage();
      return;
    }
    showSetWallpaperBottomSheet(context, detailViewModel, wallpaper.path!);
  }

  // Toggles favourite state.
  void toggleFavourite() {
    favouriteViewModel.addOrRemoveFavourite(wallpaper);
  }

  // Shares the wallpaper URL.
  void shareWallpaper() {
    Share.share(wallpaper.path ?? '');
  }

  @override
  void dispose() {
    detailViewModel.removeListener(_relay);
    favouriteViewModel.removeListener(_relay);
    _animationController?.dispose();
    transformationController.removeListener(_handleTransformChange);
    transformationController.dispose();
    useHiRes.dispose();
    super.dispose();
  }

  void _handleTransformChange() {
    final double scale = transformationController.value.getMaxScaleOnAxis();
    if (!useHiRes.value && scale > 1.2) {
      useHiRes.value = true;
    }
  }

  void _animateTo(Matrix4 target) {
    if (_animationController == null) return;
    _zoomAnimation = Matrix4Tween(
      begin: transformationController.value,
      end: target,
    ).animate(CurvedAnimation(parent: _animationController!, curve: Curves.easeOut));
    _animationController!.forward(from: 0);
  }

  void _relay() {
    notifyListeners();
  }
}
