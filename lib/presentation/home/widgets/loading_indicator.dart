import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel homeViewModel, Widget? child) {
        if (homeViewModel.loadingMoreWallpapers) {
          return Positioned(
            bottom: 0, // Position it at the bottom
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 20.h), // Add some padding from the bottom nav bar
              alignment: Alignment.center,
              child: const CustomProgressIndicator.CustomProgressIndicator(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
