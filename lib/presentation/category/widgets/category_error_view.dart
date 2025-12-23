import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class CategoryErrorView extends StatelessWidget {
  const CategoryErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            ElevatedButton(onPressed: onRetry, child: const Text(AppStrings.tryAgain)),
          ],
        ),
      ),
    );
  }
}
