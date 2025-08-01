import 'package:get/get.dart';

import '../../../../presentation/favourite/controllers/favourite.controller.dart';

class FavouriteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavouriteController>(
      () => FavouriteController(),
    );
  }
}
