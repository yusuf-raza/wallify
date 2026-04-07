import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/home/widgets/wallpaper_grid.dart';

/// The main screen of the application, displaying a list of wallpapers.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the scroll view to detect when the user reaches the bottom.
  final ScrollController _scrollController = ScrollController();
  late final HomeVM _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = Provider.of<HomeVM>(context, listen: false);
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
    final bool isDesktop = context.isDesktop;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            NotificationListener<UserScrollNotification>(
              onNotification: (UserScrollNotification notification) {
                final HomeVM controller = Provider.of<HomeVM>(context, listen: false);
                if (notification.direction == ScrollDirection.reverse) {
                  controller.setBottomBarVisible(false);
                } else if (notification.direction == ScrollDirection.forward) {
                  controller.setBottomBarVisible(true);
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () => Provider.of<HomeVM>(context, listen: false).fetchData(),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    if (!isDesktop)
                      SliverAppBar(
                        title:  Text(AppStrings.appTitle),
                        centerTitle: false,
                        floating: true,
                      ),
                    const WallpaperGrid(),
                  ],
                ),
              ),
            ),
            Consumer<HomeVM>(
              builder: (BuildContext context, HomeVM homeViewModel, Widget? child) {
                if (homeViewModel.loadingMoreWallpapers) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: context.isDesktop ? 28 : 20.h),
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
