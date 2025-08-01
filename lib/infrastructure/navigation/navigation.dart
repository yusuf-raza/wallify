import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/config.dart';
import 'package:wallify/infrastructure/navigation/bindings/initial_bindings.dart';
import 'package:wallify/infrastructure/navigation/routes.dart';
import 'package:wallify/presentation/base/base.screen.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/splash/splash.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';
import 'package:wallify/presentation/wallpaper_detail/wallpaper_detail.screen.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;

  const EnvironmentsBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String? env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(name: Routes.HOME, page: () => const HomeScreen(), binding: InitialBindings()),
    GetPage<dynamic>(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: InitialBindings(),
    ),
    GetPage<dynamic>(
      name: Routes.FAVOURITE,
      page: () => const FavouriteScreen(),
      binding: InitialBindings(),
    ),
    GetPage<dynamic>(name: Routes.BASE, page: () => const BaseScreen(), binding: InitialBindings()),
    GetPage<dynamic>(
      name: Routes.WALLPAPER_DETAIL,
      page: () => const WallpaperDetailScreen(),
      binding: InitialBindings(),
    ),
    GetPage<dynamic>(
      name: Routes.WALLPAPER_CATEGORY,
      page: () => const WallpaperCategoryScreen(),
      binding: InitialBindings(),
    ),
  ];
}
