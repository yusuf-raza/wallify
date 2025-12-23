import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/presentation/full_screen/controllers/full_screen_view_model.dart';

class FullScreenActionBar extends StatelessWidget {
  const FullScreenActionBar({super.key, required this.viewModel, required this.primaryColor});

  final FullScreenVM viewModel;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (BuildContext context, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _ActionIcon(
                      icon: Icons.save_alt,
                      label: AppStrings.save,
                      color: primaryColor,
                      isLoading: viewModel.isDownloading,
                      onTap: viewModel.saveWallpaper,
                    ),
                    _ActionIcon(
                      icon: Icons.image_outlined,
                      label: AppStrings.set,
                      color: primaryColor,
                      isLoading: viewModel.isSettingWallpaper,
                      onTap: () => viewModel.setWallpaper(context),
                    ),
                    _ActionIcon(
                      icon: viewModel.isFavourite ? Icons.favorite : Icons.favorite_border,
                      label: viewModel.isFavourite ? 'Liked' : 'Like',
                      color: primaryColor,
                      onTap: viewModel.toggleFavourite,
                    ),
                    _ActionIcon(
                      icon: Icons.share,
                      label: 'Share',
                      color: primaryColor,
                      onTap: viewModel.shareWallpaper,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.color,
    this.isLoading = false,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            else
              Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
