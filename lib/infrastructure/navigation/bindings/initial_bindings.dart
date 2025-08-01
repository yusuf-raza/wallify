import 'package:get/get.dart';
import 'package:wallify/infrastructure/theme/theme_controller.dart';
import 'package:wallify/presentation/base/controllers/base.controller.dart';
import 'package:wallify/presentation/favourite/controllers/favourite.controller.dart';
import 'package:wallify/presentation/home/controllers/home.controller.dart';
import 'package:wallify/presentation/splash/controllers/splash.controller.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category.controller.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail.controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavouriteController>(() => FavouriteController());
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<WallpaperCategoryController>(() => WallpaperCategoryController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<BaseController>(() => BaseController());
    Get.lazyPut<WallpaperDetailController>(() => WallpaperDetailController());
  }
}
