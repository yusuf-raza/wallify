import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(AppRouter.base);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.splashScreen), centerTitle: true),
      body: Center(
        child: Text(AppStrings.splashScreenWorking, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
