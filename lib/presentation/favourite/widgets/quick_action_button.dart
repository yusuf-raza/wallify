import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/app_text_styles.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isBusy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: isBusy
          ? SizedBox(
              width: 16.r,
              height: 16.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, color: AppColors.white, size: 18),
      label: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
      ),
      style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8.w)),
    );
  }
}
