import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';

class BaseViewModel extends ChangeNotifier {
  final WallpaperApi _wallpaperApi;
  final StreamController<int> _doubleTapController = StreamController<int>.broadcast();

  BaseViewModel() : _wallpaperApi = WallpaperApi() {
    getWallpapers();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Stream<int> get doubleTapStream => _doubleTapController.stream;

  List<Widget> screens = <Widget>[
    const HomeScreen(),
    const WallpaperCategoryScreen(),
    const FavouriteScreen(),
  ];

  void changeIndex(int index) {
    if (_currentIndex == index) {
      _doubleTapController.add(index);
    }
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> getWallpapers() async {
    try {
      await _wallpaperApi.getWallpapers();
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _doubleTapController.close();
    super.dispose();
  }
}
