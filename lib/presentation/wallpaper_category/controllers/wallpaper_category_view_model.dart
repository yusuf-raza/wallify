import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallify/presentation/base/controllers/base_view_model.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

class CategoryFilter {
  const CategoryFilter({required this.label, required this.query});

  final String label;
  final String query;
}

class WallpaperCategoryViewModel extends BaseViewModel {
  WallpaperCategoryViewModel({
    WallpaperApi? wallpaperApi,
    LoggerService? loggerService,
    super.connectivityService,
  })  : _wallpaperApi = wallpaperApi ?? WallpaperApi(),
        _loggerService = loggerService ?? LoggerService.instance,
        super();

  final WallpaperApi _wallpaperApi;
  final LoggerService _loggerService;

  final List<CategoryFilter> filters = const <CategoryFilter>[
    CategoryFilter(label: 'All', query: ''),
    CategoryFilter(label: 'Abstract', query: 'abstract'),
    CategoryFilter(label: 'Animals', query: 'animals'),
    CategoryFilter(label: 'Anime', query: 'anime'),
    CategoryFilter(label: 'Art', query: 'art'),
    CategoryFilter(label: 'Astrophotography', query: 'astrophotography'),
    CategoryFilter(label: 'Beach', query: 'beach'),
    CategoryFilter(label: 'Black & White', query: 'black and white'),
    CategoryFilter(label: 'Cities', query: 'city'),
    CategoryFilter(label: 'Fantasy', query: 'fantasy'),
    CategoryFilter(label: 'Fashion', query: 'fashion'),
    CategoryFilter(label: 'Fitness', query: 'fitness'),
    CategoryFilter(label: 'Food', query: 'food'),
    CategoryFilter(label: 'History', query: 'history'),
    CategoryFilter(label: 'Inspiration', query: 'inspiration quotes'),
    CategoryFilter(label: 'Mountains', query: 'mountains'),
    CategoryFilter(label: 'Music', query: 'music'),
    CategoryFilter(label: 'Nature', query: 'nature'),
    CategoryFilter(label: 'Sea', query: 'sea ocean'),
    CategoryFilter(label: 'Seasons', query: 'seasons'),
    CategoryFilter(label: 'Space', query: 'space'),
    CategoryFilter(label: 'Sports', query: 'sports'),
    CategoryFilter(label: 'Sun', query: 'sun'),
    CategoryFilter(label: 'Sunset', query: 'sunset'),
    CategoryFilter(label: 'Technology', query: 'technology'),
    CategoryFilter(label: 'Travel', query: 'travel'),
    CategoryFilter(label: 'Vehicles', query: 'vehicles'),
    CategoryFilter(label: 'Vintage', query: 'vintage'),
  ];

  CategoryFilter _selectedFilter = const CategoryFilter(label: 'All', query: '');
  CategoryFilter get selectedFilter => _selectedFilter;

  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  int _currentPage = 1;

  List<WallhavenWallpaper> wallpapers = <WallhavenWallpaper>[];
  ScrollController? _scrollController;

  void init(ScrollController controller) {
    _scrollController = controller;
    _scrollController?.addListener(() {
      if (_scrollController!.position.pixels >=
          _scrollController!.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
    fetchData();
  }

  Future<void> selectCategory(CategoryFilter filter) async {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading = true;
    isLoadingMore = false;
    errorMessage = null;
    _currentPage = 1;
    wallpapers = <WallhavenWallpaper>[];
    notifyListeners();

    try {
      final List<WallhavenWallpaper> newWallpapers = await _wallpaperApi.getWallpapers(
        page: _currentPage,
        query: _selectedFilter.query,
      );
      wallpapers = newWallpapers;
      if (wallpapers.isEmpty) {
        errorMessage = AppStrings.noWallpapersFound;
      }
    } catch (e) {
      errorMessage = AppStrings.failedToLoadWallpapers;
      _loggerService.logError('error fetching category wallpapers $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading || errorMessage != null) return;
    isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final List<WallhavenWallpaper> moreWallpapers = await _wallpaperApi.getWallpapers(
        page: _currentPage,
        query: _selectedFilter.query,
      );
      wallpapers.addAll(moreWallpapers);
    } catch (e) {
      _currentPage--;
      _loggerService.logError('error loading more category wallpapers $e');
      errorMessage ??= AppStrings.failedToLoadWallpapers;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
