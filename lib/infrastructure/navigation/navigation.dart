import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/config.dart';
import 'package:wallify/infrastructure/navigation/bindings/controllers/base.controller.binding.dart';
import 'package:wallify/infrastructure/navigation/bindings/controllers/favourite.controller.binding.dart';
import 'package:wallify/infrastructure/navigation/bindings/controllers/home.controller.binding.dart';
import 'package:wallify/infrastructure/navigation/bindings/controllers/splash.controller.binding.dart';
import 'package:wallify/infrastructure/navigation/bindings/controllers/wallpaper_category.controller.binding.dart';
import 'package:wallify/infrastructure/navigation/bindings/controllers/wallpaper_detail.controller.binding.dart';
import 'package:wallify/presentation/base/base.screen.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/splash/splash.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';
import 'package:wallify/presentation/wallpaper_detail/wallpaper_detail.screen.dart';

import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  const EnvironmentsBadge({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
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
  static List<GetPage> routes = [
    GetPage(name: Routes.HOME, page: () => const HomeScreen(), binding: HomeControllerBinding()),
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen(), binding: SplashControllerBinding()),
    GetPage(name: Routes.FAVOURITE, page: () => const FavouriteScreen(), binding: FavouriteControllerBinding()),
    GetPage(name: Routes.BASE, page: () => const BaseScreen(), binding: BaseControllerBinding()),
    GetPage(
      name: Routes.WALLPAPER_DETAIL,
      page: () => const WallpaperDetailScreen(),
      binding: WallpaperDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.WALLPAPER_CATEGORY,
      page: () => const WallpaperCategoryScreen(),
      binding: WallpaperCategoryControllerBinding(),
    ),
  ];
}
