import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/presentation/base/controllers/base_view_model.dart';
import 'package:wallify/presentation/category/widgets/category_filter_bottom_sheet.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class CategoryFilter {
  const CategoryFilter({required this.label, required this.query});

  final String label;
  final String query;
}

// Extends BaseVM to reuse connectivity-aware refresh and shared navigation wiring.
class CategoryVM extends BaseVM {
  CategoryVM({WallpaperApi? wallpaperApi, LoggerService? loggerService, super.connectivityService})
    : _wallpaperApi = wallpaperApi ?? WallpaperApi(),
      _loggerService = loggerService ?? LoggerService.instance,
      super();

  final WallpaperApi _wallpaperApi;
  final LoggerService _loggerService;
  final List<CategoryFilter> filters = const <CategoryFilter>[
    CategoryFilter(label: AppStrings.filterAbstractLabel, query: AppStrings.filterAbstractQuery),
    CategoryFilter(label: AppStrings.filterAllLabel, query: AppStrings.filterAllQuery),
    CategoryFilter(label: AppStrings.filterAnimalsLabel, query: AppStrings.filterAnimalsQuery),
    CategoryFilter(label: AppStrings.filterAnimeLabel, query: AppStrings.filterAnimeQuery),
    CategoryFilter(label: AppStrings.filterArtLabel, query: AppStrings.filterArtQuery),
    CategoryFilter(label: AppStrings.filterBeachLabel, query: AppStrings.filterBeachQuery),
    CategoryFilter(
      label: AppStrings.filterBlackWhiteLabel,
      query: AppStrings.filterBlackWhiteQuery,
    ),
    CategoryFilter(label: AppStrings.filterCitiesLabel, query: AppStrings.filterCitiesQuery),
    CategoryFilter(label: AppStrings.filterDarkLabel, query: AppStrings.filterDarkQuery),
    CategoryFilter(label: AppStrings.filterFantasyLabel, query: AppStrings.filterFantasyQuery),
    CategoryFilter(label: AppStrings.filterFashionLabel, query: AppStrings.filterFashionQuery),
    CategoryFilter(label: AppStrings.filterFitnessLabel, query: AppStrings.filterFitnessQuery),
    CategoryFilter(label: AppStrings.filterFoodLabel, query: AppStrings.filterFoodQuery),
    CategoryFilter(label: AppStrings.filterHistoryLabel, query: AppStrings.filterHistoryQuery),
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
    CategoryFilter(
      label: AppStrings.filterTechnologyLabel,
      query: AppStrings.filterTechnologyQuery,
    ),
    CategoryFilter(label: AppStrings.filterTravelLabel, query: AppStrings.filterTravelQuery),
    CategoryFilter(label: AppStrings.filterVehiclesLabel, query: AppStrings.filterVehiclesQuery),
    CategoryFilter(label: AppStrings.filterVintageLabel, query: AppStrings.filterVintageQuery),
  ];

  CategoryFilter _selectedFilter = const CategoryFilter(
    label: AppStrings.filterAbstractLabel,
    query: AppStrings.filterAbstractQuery,
  );
  CategoryFilter get selectedFilter => _selectedFilter;
  final TextEditingController searchController = TextEditingController();

  String get customSearchQuery => searchController.text.trim();
  bool get hasCustomSearch => customSearchQuery.isNotEmpty;
  String get effectiveQuery => hasCustomSearch ? customSearchQuery : _selectedFilter.query;

  // UI state
  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  int _currentPage = 1;

  List<WallhavenWallpaper> wallpapers = <WallhavenWallpaper>[];

  // Scroll and navigation wiring.
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  StreamSubscription<int>? _navDoubleTapSubscription;
  bool _hasInitialized = false;
  bool _hasScrollListener = false;

  // Initializes listeners and triggers the first load once the tab is visible.
  void ensureInitialized(HomeVM homeNavViewModel) {
    if (_hasInitialized || homeNavViewModel.currentIndex != 1) {
      return;
    }
    _hasInitialized = true;
    _bindHomeNavigation(homeNavViewModel);
    _attachScrollListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        fetchData();
      }
    });
  }

  // Toggles the bottom bar based on scroll direction.
  bool handleScrollNotification(UserScrollNotification notification, HomeVM homeNavViewModel) {
    if (notification.direction == ScrollDirection.reverse) {
      homeNavViewModel.setBottomBarVisible(false);
    } else if (notification.direction == ScrollDirection.forward) {
      homeNavViewModel.setBottomBarVisible(true);
    }
    return false;
  }

  // Opens the category filter picker.
  void showCategoryFilterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategoryFilterBottomSheet(viewModel: this);
      },
    );
  }

  // Applies a filter and reloads results.
  Future<void> selectCategory(CategoryFilter filter) async {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    if (hasCustomSearch) {
      searchController.clear();
    }
    await fetchData();
  }

  Future<void> applySearch([String? value]) async {
    final String resolvedQuery = (value ?? searchController.text).trim();
    if (resolvedQuery == searchController.text.trim() && hasCustomSearch) {
      await fetchData();
      return;
    }
    searchController
      ..text = resolvedQuery
      ..selection = TextSelection.collapsed(offset: resolvedQuery.length);
    await fetchData();
  }

  Future<void> clearSearch() async {
    if (!hasCustomSearch) return;
    searchController.clear();
    await fetchData();
  }

  // Fetches wallpapers for the selected category from page 1.
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
        query: effectiveQuery,
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

  // Loads the next page when near the end of the list.
  Future<void> loadMore() async {
    if (isLoadingMore || isLoading || errorMessage != null) return;
    isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final List<WallhavenWallpaper> moreWallpapers = await _wallpaperApi.getWallpapers(
        page: _currentPage,
        query: effectiveQuery,
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

  // Listens for bottom-nav double taps to scroll to top.
  void _bindHomeNavigation(HomeVM homeNavViewModel) {
    _navDoubleTapSubscription ??= homeNavViewModel.doubleTapStream.listen((int index) {
      if (index == 1 && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Adds the infinite scroll listener once.
  void _attachScrollListener() {
    if (_hasScrollListener) return;
    _hasScrollListener = true;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  // Cleans up subscriptions and controllers.
  @override
  void dispose() {
    _navDoubleTapSubscription?.cancel();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
