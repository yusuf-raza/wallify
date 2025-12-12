import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category_view_model.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _viewModel = Provider.of<WallpaperCategoryViewModel>(context, listen: false);
    _viewModel.init(_scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<WallpaperCategoryViewModel>(
        builder: (BuildContext context, WallpaperCategoryViewModel viewModel, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppStrings.exploreByCategory,
                          style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.black87),
                          onPressed: () => _showCategoryFilterBottomSheet(context, viewModel),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[AppColors.purple, AppColors.pink, AppColors.orange],
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
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: borderColor.withOpacity(0.7)),
                                    color: isSelected
                                        ? borderColor.withOpacity(0.2)
                                        : Colors.white.withOpacity(0.05),
                                  ),
                                  child: Text(filter.label, style: TextStyle(color: textColor)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: viewModel.fetchData,
                  child: Builder(
                    builder: (BuildContext context) {
                      if (viewModel.isLoading && viewModel.wallpapers.isEmpty) {
                        return const Center(
                          child: CustomProgressIndicator.CustomProgressIndicator(),
                        );
                      }

                      if (viewModel.errorMessage != null && viewModel.wallpapers.isEmpty) {
                        return _ErrorView(
                          message: viewModel.errorMessage!,
                          onRetry: viewModel.fetchData,
                        );
                      }

                      if (viewModel.wallpapers.isEmpty) {
                        return _ErrorView(
                          message: AppStrings.noWallpapersFound,
                          onRetry: viewModel.fetchData,
                        );
                      }

                      return Stack(
                        children: <Widget>[
                          MasonryGridView.count(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            itemCount: viewModel.wallpapers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final wallpaper = viewModel.wallpapers[index];
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
                            },
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
            ],
          );
        },
      ),
    );
  }

  void _showCategoryFilterBottomSheet(
    BuildContext context,
    WallpaperCategoryViewModel viewModel,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController controller) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView(
                controller: controller,
                children: <Widget>[
                  Text(
                    AppStrings.categories,
                    style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: viewModel.filters.map((CategoryFilter filter) {
                      final bool isSelected = filter == viewModel.selectedFilter;
                      return ChoiceChip(
                        label: Text(filter.label),
                        selected: isSelected,
                        onSelected: (_) {
                          viewModel.selectCategory(filter);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
            ElevatedButton(onPressed: onRetry, child: Text(AppStrings.tryAgain)),
          ],
        ),
      ),
    );
  }
}
