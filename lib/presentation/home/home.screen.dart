import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).getWallpapers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          crossAxisSpacing: 5, // Horizontal spacing between items
          mainAxisSpacing: 5, // Vertical spacing between items
          childAspectRatio: 0.6,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        itemCount: homeViewModel.wallpapers.length, // Number of grid items
        itemBuilder: (BuildContext context, int index) {
          final WallhavenWallpaper wallpaper = homeViewModel.wallpapers[index];
          return GridItem(
            wallpaper: wallpaper,
            onTap: () {
              context.go(AppRouter.wallpaperDetail);
            },
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // Provider.of<HomeViewModel>(context).getWallpapers();
  }
}
