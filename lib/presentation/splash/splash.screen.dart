import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/presentation/splash/controllers/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.go(AppRouter.base);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SplashViewModel splashViewModel = Provider.of<SplashViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('SplashScreen'), centerTitle: true),
      body: const Center(child: Text('SplashScreen is working', style: TextStyle(fontSize: 20))),
    );
  }
}
