import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator.CustomProgressIndicator({super.key, this.color = AppColors.white});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator.adaptive(backgroundColor: color),
      ),
    );
  }
}
