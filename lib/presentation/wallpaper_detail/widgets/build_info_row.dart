import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class BuildInfoRow extends StatelessWidget {
  const BuildInfoRow({super.key, required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 3.w,
      children: <Widget>[
        Icon(icon, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
