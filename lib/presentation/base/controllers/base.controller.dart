import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/data/api/wallpaper_api/wallpaper_api.dart';
import 'package:wallify/data/models/wallpaper.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';

class BaseController extends GetxController {
  //TODO: Implement BaseController

  RxInt currentIndex = 0.obs;

  List<Widget> screens = <Widget>[
    const HomeScreen(),
    const WallpaperCategoryScreen(),
    const FavouriteScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getWallpapers();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getWallpapers() async {
    //fetchingProjects.value = true;
    await WallpaperApi.getWallpapers(
      successCallback: (Wallpaper wallpaper) {
        LoggerService.logInfo('aaaaa   ${wallpaper.toString()}');
      },
      failureCallback: (String error) {
        //Utilities.showToast(toastMsg: error, isSuccess: false);
        LoggerService.logError('updateUserProfile failureCallback: $error');
      },
    );
    //fetchingProjects.value = false;
  }
}
