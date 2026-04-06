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
        final int crossAxisCount = context.isWideDesktop
            ? 5
            : context.isDesktop
            ? 4
            : context.isTablet
            ? 3
            : 2;
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
                          centerTitle: false,
                          floating: !context.isDesktop,
                          pinned: context.isDesktop,
                          toolbarHeight: context.isDesktop ? 88 : kToolbarHeight,
                          titleSpacing: context.isDesktop ? 0 : null,
                          title: ResponsiveContent(
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(AppStrings.categories, style: AppTextStyles.appTitle),
                                      if (context.isDesktop)
                                        Text(
                                          AppStrings.exploreByCategory,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  onPressed: () => viewModel.showCategoryFilterBottomSheet(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: ResponsiveContent(
                            padding: EdgeInsets.fromLTRB(
                              context.contentHorizontalPadding,
                              0,
                              context.contentHorizontalPadding,
                              context.isDesktop ? 20 : 8.h,
                            ),
                            child: context.isDesktop
                                ? _DesktopCategoryFilters(viewModel: viewModel)
                                : _MobileCategoryFilters(viewModel: viewModel),
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
                              padding: EdgeInsets.only(bottom: context.isDesktop ? 32 : 12.h),
                              sliver: SliverToBoxAdapter(
                                child: ResponsiveContent(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.contentHorizontalPadding,
                                  ),
                                  child: MasonryGridView.count(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: context.isDesktop ? 16 : 5,
                                    crossAxisSpacing: context.isDesktop ? 16 : 5,
                                    itemCount: viewModel.wallpapers.length,
                                    itemBuilder: (BuildContext context, int index) {
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
                                    },
                                  ),
                                ),
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

class _DesktopCategoryFilters extends StatelessWidget {
  const _DesktopCategoryFilters({required this.viewModel});

  final CategoryVM viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.purple, AppColors.pink, AppColors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  AppStrings.exploreByCategory,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (viewModel.hasCustomSearch)
                TextButton(
                  onPressed: viewModel.clearSearch,
                  child: const Text(
                    AppStrings.clearSearch,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: viewModel.searchController,
            onSubmitted: viewModel.applySearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.searchCategoriesHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: viewModel.hasCustomSearch
                  ? IconButton(
                      onPressed: viewModel.clearSearch,
                      icon: const Icon(Icons.close),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: viewModel.filters.map((CategoryFilter filter) {
              return _CategoryFilterChip(
                label: filter.label,
                isSelected: filter == viewModel.selectedFilter,
                onTap: () => viewModel.selectCategory(filter),
                isDesktop: true,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MobileCategoryFilters extends StatelessWidget {
  const _MobileCategoryFilters({required this.viewModel});

  final CategoryVM viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.purple, AppColors.pink, AppColors.orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: <Widget>[
          TextField(
            controller: viewModel.searchController,
            onSubmitted: viewModel.applySearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.searchCategories,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: viewModel.hasCustomSearch
                  ? IconButton(
                      onPressed: viewModel.clearSearch,
                      icon: const Icon(Icons.close),
                    )
                  : null,
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                final CategoryFilter filter = viewModel.filters[index];
                return _CategoryFilterChip(
                  label: filter.label,
                  isSelected: filter == viewModel.selectedFilter,
                  onTap: () => viewModel.selectCategory(filter),
                  isDesktop: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDesktop,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 18 : 14,
            vertical: isDesktop ? 12 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.12),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.36),
            ),
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.filterLabel.copyWith(
              color: isSelected ? AppColors.purple : Colors.white,
              fontSize: isDesktop ? 14 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
