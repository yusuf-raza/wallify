import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/home/widgets/error_view.dart';

/// A widget that displays the wallpapers in a responsive grid.
class WallpaperGrid extends StatelessWidget {
  const WallpaperGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
    } else if (screenWidth < 1280) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 5;
    }

    return Consumer<HomeVM>(
      builder: (BuildContext context, HomeVM homeViewModel, Widget? child) {
        if (homeViewModel.gettingWallpapers) {
          return const SliverFillRemaining(
            child: Center(child: CustomProgressIndicator.CustomProgressIndicator()),
          );
        }

        if (homeViewModel.errorMessage != null && homeViewModel.wallpapers.isEmpty) {
          return SliverFillRemaining(
            child: ErrorView(
              message: homeViewModel.errorMessage!,
              onRetry: homeViewModel.fetchData,
            ),
          );
        }

        if (homeViewModel.wallpapers.isEmpty) {
          return SliverFillRemaining(
            child: ErrorView(
              message: AppStrings.noWallpapersFound,
              onRetry: homeViewModel.fetchData,
            ),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.only(bottom: context.isDesktop ? 32 : 12.h),
          sliver: SliverToBoxAdapter(
            child: ResponsiveContent(
              padding: EdgeInsets.symmetric(horizontal: context.contentHorizontalPadding),
              child: MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: context.isDesktop ? 16 : 5,
                crossAxisSpacing: context.isDesktop ? 16 : 5,
                itemCount: homeViewModel.wallpapers.length,
                itemBuilder: (BuildContext context, int index) {
                  final WallhavenWallpaper wallpaper = homeViewModel.wallpapers[index];
                  final String heroTag =
                      'home-${wallpaper.id ?? wallpaper.path ?? 'wallpaper'}-$index';
                  return Hero(
                    tag: heroTag,
                    child: GridItem(
                      wallpaper: wallpaper,
                      onTap: () {
                        context.push(
                          AppRouter.wallpaperDetailNew,
                          extra: <String, Object?>{'wallpaper': wallpaper, 'heroTag': heroTag},
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
