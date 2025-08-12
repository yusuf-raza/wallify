import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallify/presentation/base/controllers/base.controller.dart';

class BaseScreen extends GetView<BaseController> {
  const BaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.currentIndex.value, children: controller.screens),
      ),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          currentIndex: controller.currentIndex.value,
          onTap: (int index) {
            controller.changeIndex(index);
          },
          items: <SalomonBottomBarItem>[
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.category),
              title: const Text('category'),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite),
              title: const Text('Favourite'),
              selectedColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
