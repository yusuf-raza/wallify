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
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category_view_model.dart';
import 'package:wallify/presentation/wallpaper_category/widgets/category_error_view.dart';
import 'package:wallify/presentation/wallpaper_category/widgets/category_filter_bottom_sheet.dart';

class WallpaperCategoryView extends StatefulWidget {
  const WallpaperCategoryView({super.key});

  @override
  State<WallpaperCategoryView> createState() => _WallpaperCategoryViewState();
}

class _WallpaperCategoryViewState extends State<WallpaperCategoryView> {
  late final ScrollController _scrollController;
  late final CategoryViewModel _viewModel;
  late final HomeViewModel _homeNavViewModel;
  StreamSubscription<int>? _navDoubleTapSubscription;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _viewModel = Provider.of<CategoryViewModel>(context, listen: false);
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
          child: Consumer<CategoryViewModel>(
            builder: (BuildContext context, CategoryViewModel viewModel, Widget? child) {
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
                            pinned: false,
                            title: Text(
                              AppStrings.appTitle,
                              style: AppTextStyles.appTitle,
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
                                          final bool isSelected =
                                              filter == viewModel.selectedFilter;
                                          const Color borderColor = Colors.white;
                                          const Color textColor = Colors.white;

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
                                                border: Border.all(
                                                  color: borderColor.withOpacity(0.7),
                                                ),
                                                color: isSelected
                                                    ? borderColor.withOpacity(0.3)
                                                    : Colors.white.withOpacity(0.0),
                                              ),
                                              child: Text(
                                                filter.label,
                                                style: AppTextStyles.filterLabel.copyWith(
                                                  color: textColor,
                                                ),
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
                                  child: CategoryErrorView(
                                    message: viewModel.errorMessage!,
                                    onRetry: viewModel.fetchData,
                                  ),
                                );
                              }

                              if (viewModel.wallpapers.isEmpty) {
                                return SliverFillRemaining(
                                  child: CategoryErrorView(
                                    message: AppStrings.noWallpapersFound,
                                    onRetry: viewModel.fetchData,
                                  ),
                                );
                              }

                              return SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                sliver: SliverMasonryGrid(
                                  gridDelegate:
                                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                      ),
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  delegate: SliverChildBuilderDelegate((
                                    BuildContext context,
                                    int index,
                                  ) {
                                    final WallhavenWallpaper wallpaper =
                                        viewModel.wallpapers[index];
                                    final String heroTag =
                                        'category-${wallpaper.id ?? wallpaper.path ?? 'wallpaper'}-$index';
                                    return Hero(
                                      tag: heroTag,
                                      child: GridItem(
                                        wallpaper: wallpaper,
                                        onTap: () => context.push(
                                          AppRouter.wallpaperDetailNew,
                                          extra: <String, Object?>{
                                            'wallpaper': wallpaper,
                                            'heroTag': heroTag,
                                          },
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
                      child: Center(child: CustomProgressIndicator.CustomProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCategoryFilterBottomSheet(BuildContext context, CategoryViewModel viewModel) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategoryFilterBottomSheet(viewModel: viewModel);
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
