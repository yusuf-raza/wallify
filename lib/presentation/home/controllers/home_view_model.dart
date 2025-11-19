import 'package:flutter/foundation.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

class HomeViewModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  bool gettingWallpapers = false;

  List<WallhavenWallpaper> wallpapers = <WallhavenWallpaper>[];

  void increment() {
    _count++;
    notifyListeners();
  }

  Future<void> getWallpapers() async {
    gettingWallpapers = true;
    notifyListeners();

    try {
      await WallpaperApi.getWallpapers(
        successCallback: (List<WallhavenWallpaper> p1) {
          wallpapers = p1;
          LoggerService.logInfo('wallpapers length   ${wallpapers.length}');
        },
        failureCallback: (String error) {},
      );
    } catch (e) {
      LoggerService.logError('error in getWallpapers() $e');
    } finally {
      gettingWallpapers = false;
      notifyListeners();
    }
  }
}
