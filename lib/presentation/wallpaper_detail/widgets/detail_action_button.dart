import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class DetailActionButton extends StatelessWidget {
  const DetailActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          height: 50,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: color, width: 2.w),
          ),
          child: isLoading
              ? const Center(
                  child: CustomProgressIndicator.CustomProgressIndicator(color: AppColors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 3.w,
                  children: <Widget>[
                    Icon(icon, color: color),
                    Text(label, style: TextStyle(color: color)),
                  ],
                ),
        ),
      ),
    );
  }
}
