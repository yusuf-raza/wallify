import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/infrastructure/navigation/bindings/initial_bindings.dart';
import 'package:wallify/infrastructure/navigation/navigation.dart';
import 'package:wallify/infrastructure/navigation/routes.dart';
import 'package:wallify/infrastructure/theme/theme_controller.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail.controller.dart';

void main() async {
  final String initialRoute = await Routes.initialRoute;

  Get.put(WallpaperDetailController());

  runApp(MyApp(initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp(this.initialRoute, {super.key});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return GetMaterialApp(
      themeMode: ThemeController().themeMode,
      initialRoute: initialRoute,
      initialBinding: InitialBindings(),
      getPages: Nav.routes,
    );
  }
}
