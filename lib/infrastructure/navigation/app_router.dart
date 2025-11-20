import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/presentation/base/base.screen.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/splash/splash.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';
import 'package:wallify/presentation/wallpaper_detail/wallpaper_detail.screen.dart';
import 'package:wallify/presentation/wallpaper_detail/wallpaper_detail_screen_new.dart';

class AppRouter {
  static const String splash = '/';
  static const String base = '/base';
  static const String home = '/home';
  static const String favourite = '/favourite';
  static const String wallpaperDetail = '/wallpaper-detail';
  static const String wallpaperCategory = '/wallpaper-category';
  static const String wallpaperDetailNew = '/wallpaper-detail-screen-new';

  static const String counter = '/counter';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: <GoRoute>[
      GoRoute(
        path: splash,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: base,
        builder: (BuildContext context, GoRouterState state) => const BaseScreen(),
      ),
      GoRoute(
        path: home,
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: favourite,
        builder: (BuildContext context, GoRouterState state) => const FavouriteScreen(),
      ),
      GoRoute(
        path: wallpaperDetail,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          final WallhavenWallpaper wallpaper = data['wallpaper'] as WallhavenWallpaper;
          final List<WallhavenWallpaper> wallpapers =
              data['wallpapers'] as List<WallhavenWallpaper>;

          return WallpaperDetailScreen(wallpaper: wallpaper, wallpapers: wallpapers);
        },
      ),
      GoRoute(
        path: wallpaperCategory,
        builder: (BuildContext context, GoRouterState state) => const WallpaperCategoryScreen(),
      ),

      GoRoute(
        path: wallpaperDetailNew,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          final String imgUrl = data['imgUrl'] as String;
          final String category = data['category'] as String;
          final int dimensionX = data['dimensionX'] as int;
          final int dimensionY = data['dimensionY'] as int;
          final List<dynamic> colors = data['colors'];

          final int size = data['size'] as int;

          return WallpaperDetailScreenNew(
            imgUrl: imgUrl,
            category: category,
            dimensionX: dimensionX,
            size: size,
            dimensionY: dimensionY,
            colors: colors,
          );
        },
      ),
    ],
  );
}
