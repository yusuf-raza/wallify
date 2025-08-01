import 'package:get/get.dart';

import '../../../../presentation/wallpaper_category/controllers/wallpaper_category.controller.dart';

class WallpaperCategoryControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallpaperCategoryController>(
      () => WallpaperCategoryController(),
    );
  }
}
