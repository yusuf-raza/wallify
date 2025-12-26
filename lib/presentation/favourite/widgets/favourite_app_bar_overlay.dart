import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';

class FavouriteAppBarOverlay extends StatelessWidget {
  const FavouriteAppBarOverlay({
    super.key,
    required this.appBarHeight,
    required this.themeViewModel,
    required this.favouriteViewModel,
  });

  final double appBarHeight;
  final ThemeViewModel themeViewModel;
  final FavouriteVM favouriteViewModel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: appBarHeight,
          child: AppBar(
            primary: false,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            //title: Text(AppStrings.favourite, style: AppTextStyles.screenTitle),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.dark_mode, size: 25),
                onPressed: themeViewModel.toggleTheme,
              ),
              IconButton(
                icon: Icon(favouriteViewModel.isManageMode ? Icons.done : Icons.tune),
                onPressed: favouriteViewModel.toggleManageMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
