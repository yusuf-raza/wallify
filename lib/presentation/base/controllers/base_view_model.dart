import 'package:flutter/material.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';

class BaseViewModel extends ChangeNotifier {
  BaseViewModel() {
    getWallpapers();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  List<Widget> screens = <Widget>[
    const HomeScreen(),
    const WallpaperCategoryScreen(),
    const FavouriteScreen(),
  ];

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> getWallpapers() async {
    //fetchingProjects.value = true;
    await WallpaperApi.getWallpapers(
      successCallback: (List<WallhavenWallpaper> p1) {},
      failureCallback: (String error) {},
      // successCallback: (Wallpaper wallpaper) {
      //   LoggerService.logInfo('aaaaa   ${wallpaper.toString()}');
      // },
      // failureCallback: (String error) {
      //   //Utilities.showToast(toastMsg: error, isSuccess: false);
      //   LoggerService.logError('updateUserProfile failureCallback: $error');
      // },
    );
    //fetchingProjects.value = false;
  }
}
