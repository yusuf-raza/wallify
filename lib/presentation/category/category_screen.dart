import 'package:flutter/material.dart';
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
import 'package:wallify/presentation/category/controllers/category_view_model.dart';
import 'package:wallify/presentation/category/widgets/category_error_view.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeVM, CategoryVM>(
      builder: (BuildContext context, HomeVM homeNavViewModel, CategoryVM viewModel, Widget? child) {
        viewModel.ensureInitialized(homeNavViewModel);
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                NotificationListener<UserScrollNotification>(
                  onNotification: (UserScrollNotification notification) =>
                      viewModel.handleScrollNotification(notification, homeNavViewModel),
                  child: RefreshIndicator(
                    onRefresh: viewModel.fetchData,
                    child: CustomScrollView(
                      controller: viewModel.scrollController,
                      slivers: <Widget>[
                        SliverAppBar(
                          centerTitle: true,
                          floating: true,
                          pinned: false,
                          title: Text(AppStrings.appTitle, style: AppTextStyles.appTitle),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              onPressed: () => viewModel.showCategoryFilterBottomSheet(context),
                            ),
                          ],
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(70.h),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.r),
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
                                                fontSize: 13,
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
            ),
          ),
        );
      },
    );
  }
}
