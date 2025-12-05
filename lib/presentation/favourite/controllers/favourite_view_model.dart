import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';

class FavouriteViewModel extends ChangeNotifier {
  static const String _favouriteKey = 'favouriteWallpapers';
  List<WallhavenWallpaper> _favouriteWallpapers = <WallhavenWallpaper>[];
  bool _isLoading = false;

  FavouriteViewModel() {
    _loadFavouritesOnInit();
  }

  bool get isLoading => _isLoading;
  List<WallhavenWallpaper> get favouriteWallpapers => _favouriteWallpapers;

  Future<void> _loadFavouritesOnInit() async {
    _isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favouritesString = prefs.getString(_favouriteKey);
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
    final List<Map<String, dynamic>> jsonList =
        _favouriteWallpapers.map((WallhavenWallpaper wallpaper) => wallpaper.toJson()).toList();
    await prefs.setString(_favouriteKey, jsonEncode(jsonList));
  }

  void addOrRemoveFavourite(WallhavenWallpaper wallpaper) {
    if (_favouriteWallpapers.any((WallhavenWallpaper fav) => fav.id == wallpaper.id)) {
      _favouriteWallpapers.removeWhere((WallhavenWallpaper fav) => fav.id == wallpaper.id);
    } else {
      _favouriteWallpapers.add(wallpaper);
    }
    _saveFavourites();
    notifyListeners();
  }

  bool isFavourite(WallhavenWallpaper wallpaper) {
    return _favouriteWallpapers.any((WallhavenWallpaper fav) => fav.id == wallpaper.id);
  }
}
