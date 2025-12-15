import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/home/widgets/wallpaper_grid.dart';
import 'package:flutter/rendering.dart';

/// The main screen of the application, displaying a list of wallpapers.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the scroll view to detect when the user reaches the bottom.
  final ScrollController _scrollController = ScrollController();
  late final HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.init(_scrollController);
  }

  @override
  void dispose() {
    // Dispose the scroll controller to free up resources.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            NotificationListener<UserScrollNotification>(
              onNotification: (UserScrollNotification notification) {
                final HomeViewModel controller =
                    Provider.of<HomeViewModel>(context, listen: false);
                if (notification.direction == ScrollDirection.reverse) {
                  controller.setBottomBarVisible(false);
                } else if (notification.direction == ScrollDirection.forward) {
                  controller.setBottomBarVisible(true);
                }
                return false;
              },
              child: RefreshIndicator(
                // Allows pull-to-refresh to fetch new wallpapers.
                onRefresh: () => Provider.of<HomeViewModel>(context, listen: false).fetchData(),
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
                      floating: true,
                    ),
                    // The grid of wallpapers.
                    const WallpaperGrid(),
                  ],
                ),
              ),
            ),
            // Positioned loading indicator at the bottom
            Consumer<HomeViewModel>(
              builder: (BuildContext context, HomeViewModel homeViewModel, Widget? child) {
                if (homeViewModel.loadingMoreWallpapers) {
                  return Positioned(
                    bottom: 0, // Position it at the bottom
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: 20.h,
                      ), // Add some padding from the bottom nav bar
                      alignment: Alignment.center,
                      child: const CustomProgressIndicator.CustomProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
