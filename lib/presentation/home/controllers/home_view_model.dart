import 'package:flutter/foundation.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

class HomeViewModel extends ChangeNotifier {
  final WallpaperApi _wallpaperApi;
  final LoggerService _loggerService;

  HomeViewModel({WallpaperApi? wallpaperApi, LoggerService? loggerService})
      : _wallpaperApi = wallpaperApi ?? WallpaperApi(),
        _loggerService = loggerService ?? LoggerService.instance;

  int _currentPage = 1;
  bool gettingWallpapers = false;
  bool loadingMoreWallpapers = false;

  List<WallhavenWallpaper> wallpapers = <WallhavenWallpaper>[];

  Future<void> getWallpapers() async {
    gettingWallpapers = true;
    _currentPage = 1;
    wallpapers.clear();
    notifyListeners();

    try {
      final List<WallhavenWallpaper> newWallpapers =
          await _wallpaperApi.getWallpapers(
        page: _currentPage,
      );
      wallpapers.addAll(newWallpapers);
      _loggerService.logInfo('wallpapers length   ${wallpapers.length}');
    } catch (e) {
      _loggerService.logError('error in getWallpapers() $e');
    } finally {
      gettingWallpapers = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreWallpapers() async {
    if (loadingMoreWallpapers) return;

    loadingMoreWallpapers = true;
    notifyListeners();

    try {
      _currentPage++;
      final List<WallhavenWallpaper> newWallpapers =
          await _wallpaperApi.getWallpapers(
        page: _currentPage,
      );
      wallpapers.addAll(newWallpapers);
      _loggerService.logInfo('wallpapers length   ${wallpapers.length}');
    } catch (e) {
      _currentPage--; // revert page number on error
      _loggerService.logError('error in loadMoreWallpapers() $e');
    } finally {
      loadingMoreWallpapers = false;
      notifyListeners();
    }
  }
}
