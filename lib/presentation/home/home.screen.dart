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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).getWallpapers();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<HomeViewModel>(context, listen: false).loadMoreWallpapers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeController = Provider.of<ThemeViewModel>(context, listen: false);

    return Scaffold(
      // appBar: const CustomAppBar(),
      body: RefreshIndicator(
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
            const _WallpaperGrid(),
          ],
        ),
      ),
    );
  }
}

class _WallpaperGrid extends StatelessWidget {
  const _WallpaperGrid();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel homeViewModel, Widget? child) {
        if (homeViewModel.gettingWallpapers) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
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
                if (index == homeViewModel.wallpapers.length) {
                  return homeViewModel.loadingMoreWallpapers
                      ? const Center(child: CircularProgressIndicator.adaptive())
                      : const SizedBox.shrink();
                }
                final WallhavenWallpaper wallpaper = homeViewModel.wallpapers[index];
                return GridItem(
                  wallpaper: wallpaper,
                  onTap: () {
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
              childCount:
                  homeViewModel.wallpapers.length + (homeViewModel.loadingMoreWallpapers ? 1 : 0),
            ),
          ),
        );
      },
    );
  }
}
