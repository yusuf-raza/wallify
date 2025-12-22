import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/presentation/base/controllers/base_view_model.dart';

class CategoryFilter {
  const CategoryFilter({required this.label, required this.query});

  final String label;
  final String query;
}

class CategoryViewModel extends BaseViewModel {
  CategoryViewModel({
    WallpaperApi? wallpaperApi,
    LoggerService? loggerService,
    super.connectivityService,
  }) : _wallpaperApi = wallpaperApi ?? WallpaperApi(),
       _loggerService = loggerService ?? LoggerService.instance,
       super();

  final WallpaperApi _wallpaperApi;
  final LoggerService _loggerService;

  final List<CategoryFilter> filters = const <CategoryFilter>[
    CategoryFilter(label: AppStrings.filterAllLabel, query: AppStrings.filterAllQuery),
    CategoryFilter(label: AppStrings.filterAbstractLabel, query: AppStrings.filterAbstractQuery),
    CategoryFilter(label: AppStrings.filterAnimalsLabel, query: AppStrings.filterAnimalsQuery),
    CategoryFilter(label: AppStrings.filterAnimeLabel, query: AppStrings.filterAnimeQuery),
    CategoryFilter(label: AppStrings.filterArtLabel, query: AppStrings.filterArtQuery),
    CategoryFilter(label: AppStrings.filterBeachLabel, query: AppStrings.filterBeachQuery),
    CategoryFilter(label: AppStrings.filterBlackWhiteLabel, query: AppStrings.filterBlackWhiteQuery),
    CategoryFilter(label: AppStrings.filterCitiesLabel, query: AppStrings.filterCitiesQuery),
    CategoryFilter(label: AppStrings.filterDarkLabel, query: AppStrings.filterDarkQuery),
    CategoryFilter(label: AppStrings.filterFantasyLabel, query: AppStrings.filterFantasyQuery),
    CategoryFilter(label: AppStrings.filterFashionLabel, query: AppStrings.filterFashionQuery),
    CategoryFilter(label: AppStrings.filterFitnessLabel, query: AppStrings.filterFitnessQuery),
    CategoryFilter(label: AppStrings.filterFoodLabel, query: AppStrings.filterFoodQuery),
    CategoryFilter(label: AppStrings.filterHistoryLabel, query: AppStrings.filterHistoryQuery),
    CategoryFilter(label: AppStrings.filterHotLabel, query: AppStrings.filterHotQuery),
    CategoryFilter(
      label: AppStrings.filterInspirationLabel,
      query: AppStrings.filterInspirationQuery,
    ),
    CategoryFilter(label: AppStrings.filterMountainsLabel, query: AppStrings.filterMountainsQuery),
    CategoryFilter(label: AppStrings.filterMusicLabel, query: AppStrings.filterMusicQuery),
    CategoryFilter(label: AppStrings.filterNatureLabel, query: AppStrings.filterNatureQuery),
    CategoryFilter(label: AppStrings.filterSeaLabel, query: AppStrings.filterSeaQuery),
    CategoryFilter(label: AppStrings.filterSeasonsLabel, query: AppStrings.filterSeasonsQuery),
    CategoryFilter(label: AppStrings.filterSpaceLabel, query: AppStrings.filterSpaceQuery),
    CategoryFilter(label: AppStrings.filterSportsLabel, query: AppStrings.filterSportsQuery),
    CategoryFilter(label: AppStrings.filterSunLabel, query: AppStrings.filterSunQuery),
    CategoryFilter(label: AppStrings.filterSunsetLabel, query: AppStrings.filterSunsetQuery),
    CategoryFilter(label: AppStrings.filterTechnologyLabel, query: AppStrings.filterTechnologyQuery),
    CategoryFilter(label: AppStrings.filterTravelLabel, query: AppStrings.filterTravelQuery),
    CategoryFilter(label: AppStrings.filterVehiclesLabel, query: AppStrings.filterVehiclesQuery),
    CategoryFilter(label: AppStrings.filterVintageLabel, query: AppStrings.filterVintageQuery),
  ];

  CategoryFilter _selectedFilter = const CategoryFilter(
    label: AppStrings.filterAllLabel,
    query: AppStrings.filterAllQuery,
  );
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
      if (_scrollController!.position.pixels >= _scrollController!.position.maxScrollExtent - 200) {
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

  @override
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
