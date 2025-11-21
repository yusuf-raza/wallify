import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

/// The main screen of the application, displaying a list of wallpapers.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the scroll view to detect when the user reaches the bottom.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial wallpapers after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).getWallpapers();
    });
    // Add a listener to the scroll controller to load more wallpapers on reaching the end.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<HomeViewModel>(context, listen: false).loadMoreWallpapers();
      }
    });
  }

  @override
  void dispose() {
    // Dispose the scroll controller to free up resources.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeController = Provider.of<ThemeViewModel>(context, listen: false);

    return Scaffold(
      // appBar: const CustomAppBar(),
      body: RefreshIndicator(
        // Allows pull-to-refresh to fetch new wallpapers.
        onRefresh: () => Provider.of<HomeViewModel>(context, listen: false).getWallpapers(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                AppStrings.appTitle,
                style: TextStyle(fontSize: 100.px, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                // Theme toggle button.
                Consumer<ThemeViewModel>(
                  builder: (BuildContext context, ThemeViewModel theme, Widget? child) =>
                      IconButton(
                        icon: const Icon(Icons.dark_mode, size: 25),
                        onPressed: theme.toggleTheme,
                      ),
                ),
              ],
              centerTitle: true,
              pinned: false,
              floating: false,
            ),
            // The grid of wallpapers.
            const _WallpaperGrid(),
            // Shows a loading indicator at the bottom when loading more wallpapers.
            Consumer<HomeViewModel>(
              builder: (BuildContext context, HomeViewModel homeViewModel, Widget? child) {
                if (homeViewModel.loadingMoreWallpapers) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 80.0, // Give it some height
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays the wallpapers in a responsive grid.
class _WallpaperGrid extends StatelessWidget {
  const _WallpaperGrid();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Determine the number of columns based on the screen width.
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }
    // Use a Consumer to listen for changes in the HomeViewModel.
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel homeViewModel, Widget? child) {
        // Show a loading indicator while fetching initial wallpapers.
        if (homeViewModel.gettingWallpapers) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        // Display the wallpapers in a grid.
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 5, // Horizontal spacing between items
              mainAxisSpacing: 5, // Vertical spacing between items
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final WallhavenWallpaper wallpaper = homeViewModel.wallpapers[index];
                // Each item in the grid.
                return GridItem(
                  wallpaper: wallpaper,
                  onTap: () {
                    // Navigate to the wallpaper detail screen on tap.
                    context.go(
                      AppRouter.wallpaperDetailNew,
                      extra: <String, Object>{
                        'imgUrl': '${wallpaper.path}'!,
                        'dimensionX': wallpaper.dimensionX!,
                        'dimensionY': wallpaper.dimensionY!,
                        'category': wallpaper.category!,
                        'size': wallpaper.fileSize!,
                        'colors': wallpaper.colors!,
                      },
                    );
                  },
                );
              },
              childCount: homeViewModel.wallpapers.length,
            ),
          ),
        );
      },
    );
  }
}
