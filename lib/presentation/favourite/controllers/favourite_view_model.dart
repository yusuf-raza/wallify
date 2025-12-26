import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/constants/shared_prefs_keys.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

class FavouriteVM extends ChangeNotifier {
  static const String _albumName = 'Wallify';
  List<WallhavenWallpaper> _favouriteWallpapers = <WallhavenWallpaper>[];
  bool _isLoading = false;
  bool _isDownloading = false;
  int _downloadTotal = 0;
  int _downloadCompleted = 0;
  bool _isManageMode = false;
  bool _autoPlay = true;
  int _currentIndex = 0;
  final Set<String> _selectedIds = <String>{};
  final LoggerService _loggerService;

  FavouriteVM({LoggerService? loggerService})
    : _loggerService = loggerService ?? LoggerService.instance {
    _loadFavouritesOnInit();
  }

  bool get isLoading => _isLoading;
  bool get isDownloading => _isDownloading;
  int get downloadTotal => _downloadTotal;
  int get downloadCompleted => _downloadCompleted;
  bool get isManageMode => _isManageMode;
  bool get autoPlay => _autoPlay;
  int get currentIndex => _currentIndex;
  int get selectedCount => _selectedIds.length;
  List<WallhavenWallpaper> get favouriteWallpapers => _favouriteWallpapers;
  int get totalWallpapers => _favouriteWallpapers.length;
  bool get isMultiDownloadInProgress => _isDownloading && _downloadTotal > 1;
  bool get canManageSelection => _selectedIds.isNotEmpty && !_isDownloading;
  String get downloadProgressLabel =>
      AppStrings.downloadProgress(_downloadCompleted, _downloadTotal);
  String get downloadActionLabel =>
      _isDownloading ? AppStrings.downloadingEllipsis : AppStrings.download;
  String get removeSelectionLabel => AppStrings.removeCount(_selectedIds.length);
  String get downloadSelectionLabel => _isDownloading
      ? AppStrings.downloadingEllipsis
      : AppStrings.downloadCount(_selectedIds.length);

  WallhavenWallpaper? get currentWallpaper {
    if (_favouriteWallpapers.isEmpty) {
      return null;
    }
    final int safeIndex = _currentIndex.clamp(0, _favouriteWallpapers.length - 1);
    return _favouriteWallpapers[safeIndex];
  }

  String get currentBackgroundUrl => currentWallpaper?.path ?? '';

  Future<void> _loadFavouritesOnInit() async {
    _isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favouritesString = prefs.getString(SharedPrefsKeys.favouriteWallpapers);
    if (favouritesString != null) {
      final List<dynamic> jsonList = jsonDecode(favouritesString) as List<dynamic>;
      _favouriteWallpapers = jsonList
          .map((dynamic json) => WallhavenWallpaper.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveFavourites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = _favouriteWallpapers
        .map((WallhavenWallpaper wallpaper) => wallpaper.toJson())
        .toList();
    await prefs.setString(SharedPrefsKeys.favouriteWallpapers, jsonEncode(jsonList));
  }

  void addOrRemoveFavourite(WallhavenWallpaper wallpaper) {
    if (_favouriteWallpapers.any((WallhavenWallpaper fav) => fav.id == wallpaper.id)) {
      _favouriteWallpapers.removeWhere((WallhavenWallpaper fav) => fav.id == wallpaper.id);
    } else {
      _favouriteWallpapers.add(wallpaper);
    }
    if (_favouriteWallpapers.isEmpty) {
      _isManageMode = false;
      _selectedIds.clear();
    }
    _saveFavourites();
    notifyListeners();
  }

  bool isFavourite(WallhavenWallpaper wallpaper) {
    return _favouriteWallpapers.any((WallhavenWallpaper fav) => fav.id == wallpaper.id);
  }

  bool isSelected(WallhavenWallpaper wallpaper) {
    return _selectedIds.contains(_wallpaperKey(wallpaper));
  }

  void toggleSelection(WallhavenWallpaper wallpaper) {
    final String id = _wallpaperKey(wallpaper);
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void toggleManageMode() {
    _isManageMode = !_isManageMode;
    if (!_isManageMode) {
      _selectedIds.clear();
    }
    notifyListeners();
  }

  void toggleAutoplay() {
    _autoPlay = !_autoPlay;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }

  void removeSelectedFavourites() {
    if (_selectedIds.isEmpty) {
      return;
    }
    _favouriteWallpapers.removeWhere(
      (WallhavenWallpaper wallpaper) => _selectedIds.contains(_wallpaperKey(wallpaper)),
    );
    _selectedIds.clear();
    if (_favouriteWallpapers.isEmpty) {
      _isManageMode = false;
    }
    _saveFavourites();
    notifyListeners();
  }

  Future<void> downloadSelectedWallpapers() async {
    if (_selectedIds.isEmpty) {
      return;
    }
    final List<WallhavenWallpaper> selected = _favouriteWallpapers
        .where((WallhavenWallpaper wallpaper) => _selectedIds.contains(_wallpaperKey(wallpaper)))
        .toList();
    await downloadWallpapers(selected);
  }

  Future<void> downloadSingleWallpaper(WallhavenWallpaper wallpaper) async {
    await downloadWallpapers(<WallhavenWallpaper>[wallpaper]);
  }

  Future<void> downloadWallpapers(List<WallhavenWallpaper> wallpapers) async {
    if (wallpapers.isEmpty) {
      return;
    }

    _isDownloading = true;
    _downloadTotal = wallpapers.length;
    _downloadCompleted = 0;
    notifyListeners();

    try {
      final PermissionStatus status = await Permission.photos.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(
          msg: AppStrings.storagePermissionDenied,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.red,
          textColor: AppColors.white,
        );
        return;
      }

      int successCount = 0;
      for (final WallhavenWallpaper wallpaper in wallpapers) {
        final String? imageUrl = wallpaper.path;
        if (imageUrl == null || imageUrl.isEmpty) {
          _downloadCompleted++;
          notifyListeners();
          continue;
        }
        try {
          final bool? result = await GallerySaver.saveImage(
            imageUrl,
            albumName: _albumName,
            toDcim: false,
          );
          if (result == true) {
            successCount++;
          }
        } catch (e) {
          _loggerService.logError('failed to save $e');
        } finally {
          _downloadCompleted++;
          notifyListeners();
        }
      }

      final String message = successCount == 0
          ? AppStrings.noWallpapersSaved
          : AppStrings.savedWallpapers(successCount);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: successCount == 0 ? AppColors.red : AppColors.green,
        textColor: AppColors.white,
      );
    } catch (e) {
      _loggerService.logError('failed to save $e');
      Fluttertoast.showToast(
        msg: AppStrings.failedToSaveWallpaper,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
      );
    } finally {
      _isDownloading = false;
      _downloadTotal = 0;
      _downloadCompleted = 0;
      notifyListeners();
    }
  }

  String _wallpaperKey(WallhavenWallpaper wallpaper) {
    return wallpaper.id ?? wallpaper.path ?? wallpaper.hashCode.toString();
  }
}
