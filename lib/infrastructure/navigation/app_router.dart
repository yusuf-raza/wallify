import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/presentation/base/base_screen.dart';
import 'package:wallify/presentation/category/category_screen.dart';
import 'package:wallify/presentation/favourite/favourite_screen.dart';
import 'package:wallify/presentation/home/home_screen.dart';
import 'package:wallify/presentation/wallpaper_detail/detail_screen.dart';

class AppRouter {
  static const String base = '/base';
  static const String home = '/home';
  static const String favourite = '/favourite';
  static const String wallpaperDetail = '/wallpaper-detail';
  static const String wallpaperCategory = '/wallpaper-category';
  static const String wallpaperDetailNew = '/wallpaper-detail-screen-new';

  static const String counter = '/counter';

  static final GoRouter router = GoRouter(
    initialLocation: base,
    routes: <GoRoute>[
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
        path: wallpaperCategory,
        builder: (BuildContext context, GoRouterState state) => const CategoryScreen(),
      ),

      GoRoute(
        path: wallpaperDetailNew,
        builder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;
          if (extra is Map<String, Object?>) {
            final WallhavenWallpaper wallpaper = extra['wallpaper']! as WallhavenWallpaper;
            final String? heroTag = extra['heroTag'] as String?;
            return DetailScreen(wallpaper: wallpaper, heroTag: heroTag);
          }
          final WallhavenWallpaper wallpaper = extra! as WallhavenWallpaper;
          return DetailScreen(wallpaper: wallpaper);
        },
      ),
    ],
  );
}
