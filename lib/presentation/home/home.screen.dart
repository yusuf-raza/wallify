import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/infrastructure/common/grid_item.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeController = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          crossAxisSpacing: 5, // Horizontal spacing between items
          mainAxisSpacing: 5, // Vertical spacing between items
          childAspectRatio: 0.6,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        itemCount: 100, // Number of grid items
        itemBuilder: (BuildContext context, int index) {
          return GridItem(
            index: index,
            onTap: () {
              context.go(AppRouter.wallpaperDetail);
            },
          );
        },
      ),
    );
  }
}
