import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(message),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onRetry, child: const Text(AppStrings.tryAgain)),
      ],
    );
  }
}
