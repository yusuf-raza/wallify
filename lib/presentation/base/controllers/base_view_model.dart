import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/utils/connectivity_service.dart';
import 'package:wallify/presentation/category/category_screen.dart';
import 'package:wallify/presentation/favourite/favourite_screen.dart';
import 'package:wallify/presentation/home/home_screen.dart';

abstract class BaseVM extends ChangeNotifier {
  final StreamController<int> _doubleTapController = StreamController<int>.broadcast();
  final ConnectivityService _connectivityService;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = true;

  BaseVM({ConnectivityService? connectivityService})
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
    const CategoryScreen(),
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
    final bool isOnline = !result.contains(ConnectivityResult.none);
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
