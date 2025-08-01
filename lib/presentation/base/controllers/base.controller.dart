import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallify/presentation/favourite/favourite.screen.dart';
import 'package:wallify/presentation/home/home.screen.dart';
import 'package:wallify/presentation/wallpaper_category/wallpaper_category.screen.dart';

class BaseController extends GetxController {
  //TODO: Implement BaseController

  final count = 0.obs;

  RxInt currentIndex = 0.obs;

  List<Widget> screens = [HomeScreen(), WallpaperCategoryScreen(), FavouriteScreen()];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
