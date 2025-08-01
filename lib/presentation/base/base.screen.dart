import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'controllers/base.controller.dart';

class BaseScreen extends GetView<BaseController> {
  const BaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.screens,
        )),
        bottomNavigationBar: Obx(() => SalomonBottomBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeIndex(index);
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.category),
              title: Text("category"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.favorite),
              title: Text("Favourite"),
              selectedColor: Colors.orange,
            ),
          ],
        )));
  }
}
