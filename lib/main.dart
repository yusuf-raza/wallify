import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/base/controllers/base_view_model.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/splash/controllers/splash_view_model.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(create: (_) => BaseViewModel()),
        ChangeNotifierProvider(create: (_) => FavouriteViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => WallpaperCategoryViewModel()),
        ChangeNotifierProvider(create: (_) => WallpaperDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Consumer<ThemeViewModel>(
      builder: (BuildContext context, ThemeViewModel themeController, Widget? child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          themeMode: themeController.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          builder: (context, child) {
            Responsive.init(context);
            return child!;
          },
        );
      },
    );
  }
}
