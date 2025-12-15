import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category_view_model.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class WallpaperCategoryScreen extends StatelessWidget {
  const WallpaperCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _WallpaperCategoryView();
  }
}

class _WallpaperCategoryView extends StatefulWidget {
  const _WallpaperCategoryView();

  @override
  State<_WallpaperCategoryView> createState() => _WallpaperCategoryViewState();
}

class _WallpaperCategoryViewState extends State<_WallpaperCategoryView> {
  late final ScrollController _scrollController;
  late final WallpaperCategoryViewModel _viewModel;
  late final HomeViewModel _homeNavViewModel;
  StreamSubscription<int>? _navDoubleTapSubscription;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _viewModel = Provider.of<WallpaperCategoryViewModel>(context, listen: false);
    _homeNavViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _navDoubleTapSubscription = _homeNavViewModel.doubleTapStream.listen((int index) {
      if (index == 1 && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _navDoubleTapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel homeNavViewModel, Widget? child) {
        _initializeIfNeeded(homeNavViewModel);
        return child!;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<WallpaperCategoryViewModel>(
            builder: (BuildContext context, WallpaperCategoryViewModel viewModel, Widget? child) {
              return Stack(
                children: <Widget>[
                  NotificationListener<UserScrollNotification>(
                    onNotification: (UserScrollNotification notification) {
                      if (notification.direction == ScrollDirection.reverse) {
                        _homeNavViewModel.setBottomBarVisible(false);
                      } else if (notification.direction == ScrollDirection.forward) {
                        _homeNavViewModel.setBottomBarVisible(true);
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: viewModel.fetchData,
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            centerTitle: true,
                            floating: true,
                           // snap: true,
                            pinned: false,
                            title: Text(
                              AppStrings.appTitle,
                              style: TextStyle(fontSize: 100.px, fontWeight: FontWeight.bold),
                            ),
                            actions: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.filter_list),
                                onPressed: () => _showCategoryFilterBottomSheet(context, viewModel),
                              ),
                            ],
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(70.h),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          AppColors.purple,
                                          AppColors.pink,
                                          AppColors.orange,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 52.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: viewModel.filters.length,
                                        separatorBuilder: (_, __) => SizedBox(width: 8.w),
                                        itemBuilder: (BuildContext context, int index) {
                                          final CategoryFilter filter = viewModel.filters[index];
                                          final bool isSelected = filter == viewModel.selectedFilter;
                                          final Color borderColor = Colors.white;
                                          final Color textColor = Colors.white;

                                          return InkWell(
                                            onTap: () => viewModel.selectCategory(filter),
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 10.h,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.r),
                                                border: Border.all(color: borderColor.withOpacity(0.7)),
                                                color: isSelected
                                                    ? borderColor.withOpacity(0.3)
                                                    : Colors.white.withOpacity(0.0),
                                              ),
                                              child: Text(
                                                filter.label,
                                                style: TextStyle(color: textColor),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              if (viewModel.isLoading && viewModel.wallpapers.isEmpty) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: CustomProgressIndicator.CustomProgressIndicator(),
                                  ),
                                );
                              }

                              if (viewModel.errorMessage != null && viewModel.wallpapers.isEmpty) {
                                return SliverFillRemaining(
                                  child: _ErrorView(
                                    message: viewModel.errorMessage!,
                                    onRetry: viewModel.fetchData,
                                  ),
                                );
                              }

                              if (viewModel.wallpapers.isEmpty) {
                                return SliverFillRemaining(
                                  child: _ErrorView(
                                    message: AppStrings.noWallpapersFound,
                                    onRetry: viewModel.fetchData,
                                  ),
                                );
                              }

                              return SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w,),
                                sliver: SliverMasonryGrid(
                                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  delegate: SliverChildBuilderDelegate((
                                    BuildContext context,
                                    int index,
                                  ) {
                                    final WallhavenWallpaper wallpaper = viewModel.wallpapers[index];
                                    return Hero(
                                      tag: wallpaper.path!,
                                      child: GridItem(
                                        wallpaper: wallpaper,
                                        onTap: () => context.push(
                                          AppRouter.wallpaperDetailNew,
                                          extra: wallpaper,
                                        ),
                                      ),
                                    );
                                  }, childCount: viewModel.wallpapers.length),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.isLoadingMore)
                    const Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CustomProgressIndicator.CustomProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCategoryFilterBottomSheet(BuildContext context, WallpaperCategoryViewModel viewModel) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController controller) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      AppColors.purple,
                      AppColors.pink,
                      AppColors.orange,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: ListView(
                    controller: controller,
                    children: <Widget>[
                      Text(
                        AppStrings.categories,
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: viewModel.filters.map((CategoryFilter filter) {
                          final bool isSelected = filter == viewModel.selectedFilter;
                          return ChoiceChip(
                            label: Text(filter.label, style: const TextStyle(color: Colors.white)),
                            selected: isSelected,
                            selectedColor: Colors.white.withOpacity(0.2),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            onSelected: (_) {
                              viewModel.selectCategory(filter);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _initializeIfNeeded(HomeViewModel homeNavViewModel) {
    if (_hasInitialized || homeNavViewModel.currentIndex != 1) {
      return;
    }
    _hasInitialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _viewModel.init(_scrollController);
    });
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            ElevatedButton(onPressed: onRetry, child: const Text(AppStrings.tryAgain)),
          ],
        ),
      ),
    );
  }
}
