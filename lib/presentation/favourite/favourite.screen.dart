import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/common/custom_app_bar.dart';
import 'controllers/favourite.controller.dart';

class FavouriteScreen extends GetView<FavouriteController> {
  const FavouriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: Text('FavouriteScreen is working', style: TextStyle(fontSize: 20))),
    );
  }
}
