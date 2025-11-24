import 'package:flutter/material.dart';

Color fromHex(String hex) {
  return Color(int.parse('0xFF${hex.replaceFirst('#', '')}'));
}
