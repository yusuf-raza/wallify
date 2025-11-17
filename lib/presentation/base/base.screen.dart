import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallify/presentation/base/controllers/base_view_model.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<BaseViewModel>(
      builder: (BuildContext context, BaseViewModel controller, Widget? child) {
        return Scaffold(
          body: IndexedStack(index: controller.currentIndex, children: controller.screens),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: controller.currentIndex,
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
        );
      },
    );
  }
}
