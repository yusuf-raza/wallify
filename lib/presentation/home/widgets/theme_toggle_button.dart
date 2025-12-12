import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (BuildContext context, ThemeViewModel theme, Widget? child) =>
          IconButton(icon: const Icon(Icons.dark_mode, size: 25), onPressed: theme.toggleTheme),
    );
  }
}
