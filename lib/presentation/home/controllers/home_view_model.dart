import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/presentation/base/controllers/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final LoggerService _loggerService;
  final WallpaperApi _wallpaperApi;

  HomeViewModel({
    LoggerService? loggerService,
    super.connectivityService,
    WallpaperApi? wallpaperApi,
  }) : _loggerService = loggerService ?? LoggerService.instance,
       _wallpaperApi = wallpaperApi ?? WallpaperApi() {
    fetchData();
  }

  int _currentPage = 1;
  bool gettingWallpapers = false;
  bool loadingMoreWallpapers = false;
  String? errorMessage;
  bool _isBottomBarVisible = true;

  List<WallhavenWallpaper> wallpapers = <WallhavenWallpaper>[];

  StreamSubscription<int>? _doubleTapSubscription;
  ScrollController? _scrollController;

  void init(ScrollController scrollController) {
    _scrollController = scrollController;
    _scrollController!.addListener(() {
      if (_scrollController!.position.pixels == _scrollController!.position.maxScrollExtent) {
        loadMoreWallpapers();
      }
    });

    _doubleTapSubscription = doubleTapStream.listen((int index) {
      if (index == 0 && _scrollController != null) {
        _scrollController!.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Future<void> fetchData() async {
    gettingWallpapers = true;
    errorMessage = null;
    _currentPage = 1;
    wallpapers.clear();
    notifyListeners();

    try {
      final List<WallhavenWallpaper> newWallpapers = await _wallpaperApi.getWallpapers(
        page: _currentPage,
      );
      wallpapers.addAll(newWallpapers);
      _loggerService.logInfo('wallpapers length   ${wallpapers.length}');
    } catch (e) {
      _loggerService.logError('error in getWallpapers() $e');
      errorMessage = AppStrings.failedToLoadWallpapers;
    } finally {
      gettingWallpapers = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreWallpapers() async {
    if (loadingMoreWallpapers) return;

    loadingMoreWallpapers = true;
    errorMessage = null;
    notifyListeners();

    try {
      _currentPage++;
      final List<WallhavenWallpaper> newWallpapers = await _wallpaperApi.getWallpapers(
        page: _currentPage,
      );
      wallpapers.addAll(newWallpapers);
      _loggerService.logInfo('wallpapers length   ${wallpapers.length}');
    } catch (e) {
      _currentPage--; // revert page number on error
      _loggerService.logError('error in loadMoreWallpapers() $e');
      errorMessage ??= AppStrings.failedToLoadWallpapers;
    } finally {
      loadingMoreWallpapers = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _doubleTapSubscription?.cancel();
    super.dispose();
  }

  bool get isBottomBarVisible => _isBottomBarVisible;

  void setBottomBarVisible(bool isVisible) {
    if (_isBottomBarVisible == isVisible) {
      return;
    }
    _isBottomBarVisible = isVisible;
    notifyListeners();
  }
}
