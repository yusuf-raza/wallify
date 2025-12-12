import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/utils/connectivity_service.dart';
import 'package:wallify/infrastructure/utils/connectivity_service.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';

abstract class BaseViewModel extends ChangeNotifier {
  final StreamController<int> _doubleTapController = StreamController<int>.broadcast();
  final ConnectivityService _connectivityService;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = true;

  BaseViewModel({ConnectivityService? connectivityService})
    : _connectivityService = connectivityService ?? ConnectivityService() {
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      onConnectivityChanged,
    );
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

  Future<void> onConnectivityChanged(List<ConnectivityResult> result) async {
    final isOnline = !result.contains(ConnectivityResult.none);
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      if (_isOnline) {
        await fetchData();
      }
    }
  }

  Future<void> fetchData();

  @override
  void dispose() {
    _doubleTapController.close();
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
