import 'package:get/get.dart';

import '../../../../presentation/wallpaper_detail/controllers/wallpaper_detail.controller.dart';

class WallpaperDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallpaperDetailController>(
      () => WallpaperDetailController(),
    );
  }
}
