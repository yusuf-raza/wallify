import 'package:get/get.dart';

import '../../../../presentation/base/controllers/base.controller.dart';

class BaseControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(
      () => BaseController(),
    );
  }
}
