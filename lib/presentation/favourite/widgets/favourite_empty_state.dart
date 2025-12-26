import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class FavouriteEmptyState extends StatelessWidget {
  const FavouriteEmptyState({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.favorite_border, size: 90.px, color: AppColors.grey),
            SizedBox(height: 12.h),
            Text(AppStrings.noFavouriteWallpapers, style: AppTextStyles.emptyStateTitle),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onBrowse,
              child: Text(
                AppStrings.browseWallpapers,
                style: AppTextStyles.emptyStateTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
