import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class FavouriteManageModeView extends StatelessWidget {
  const FavouriteManageModeView({
    super.key,
    required this.wallpapers,
    required this.isSelected,
    required this.onToggleSelection,
    required this.canManageSelection,
    required this.removeSelectionLabel,
    required this.isDownloading,
    required this.downloadProgressLabel,
    required this.downloadSelectionLabel,
    required this.onRemoveSelected,
    required this.onDownloadSelected,
    required this.onCancel,
  });

  final List<WallhavenWallpaper> wallpapers;
  final bool Function(WallhavenWallpaper wallpaper) isSelected;
  final void Function(WallhavenWallpaper wallpaper) onToggleSelection;
  final bool canManageSelection;
  final String removeSelectionLabel;
  final bool isDownloading;
  final String downloadProgressLabel;
  final String downloadSelectionLabel;
  final VoidCallback onRemoveSelected;
  final VoidCallback onDownloadSelected;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = context.isWideDesktop
        ? 5
        : context.isDesktop
        ? 4
        : MediaQuery.of(context).size.width > 700
        ? 3
        : 2;

    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: context.isDesktop ? 0 : 6.w,
              vertical: context.isDesktop ? 0 : 2.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: context.isDesktop ? 16 : 8.w,
              mainAxisSpacing: context.isDesktop ? 16 : 8.h,
            ),
            itemCount: wallpapers.length,
            itemBuilder: (BuildContext context, int index) {
              final WallhavenWallpaper wallpaper = wallpapers[index];
              final bool selected = isSelected(wallpaper);
              return GestureDetector(
                onTap: () => onToggleSelection(wallpaper),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: wallpaper.thumbs?.small ?? wallpaper.path ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.blackWithOpacity,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          selected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: selected ? AppColors.green : AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.blackWithOpacity,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isDownloading)
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text(
                    downloadProgressLabel,
                    style: AppTextStyles.labelSmallBold,
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.w,
                runSpacing: 4.h,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: canManageSelection ? onRemoveSelected : null,
                    icon: const Icon(Icons.delete),
                    label: Text(removeSelectionLabel),
                  ),
                  TextButton.icon(
                    onPressed: canManageSelection ? onDownloadSelected : null,
                    icon: isDownloading
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download),
                    label: Text(downloadSelectionLabel),
                  ),
                  TextButton(
                    onPressed: onCancel,
                    child: const Text(AppStrings.cancel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
