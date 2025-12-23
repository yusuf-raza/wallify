import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/connectivity_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/category/controllers/category_view_model.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConnectivityService().init();
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<FavouriteVM>(create: (_) => FavouriteVM()),
        ChangeNotifierProvider<HomeVM>(create: (_) => HomeVM()),
        ChangeNotifierProvider<CategoryVM>(create: (_) => CategoryVM()),
        ChangeNotifierProvider<WallpaperDetailVM>(create: (_) => WallpaperDetailVM()),
        ChangeNotifierProvider<ThemeViewModel>(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = ConnectivityService().connectivityStream.listen((
      List<ConnectivityResult> result,
    ) {
      setState(() {
        _isOffline = result.contains(ConnectivityResult.none);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Consumer<ThemeViewModel>(
      builder: (BuildContext context, ThemeViewModel themeController, Widget? child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          themeMode: themeController.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          builder: (BuildContext context, Widget? child) {
            Responsive.init(context);
            return Stack(children: <Widget>[child!, if (_isOffline) _buildOfflineBanner()]);
          },
        );
      },
    );
  }

  Widget _buildOfflineBanner() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.red,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            AppStrings.noInternetConnection,
            style: AppTextStyles.banner.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
