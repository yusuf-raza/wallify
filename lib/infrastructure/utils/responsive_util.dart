import 'package:flutter/material.dart';

extension ResponsiveDimensions on num {
  static double _designWidth = 375.0; // Reference design width (e.g., iPhone 11)
  static double _designHeight = 812.0; // Reference design height (e.g., iPhone 11)

  /// Scales a width value based on the screen's width relative to the design width.
  double get w => (this * MediaQueryData.fromView(WidgetsBinding.instance.window).size.width) / _designWidth;

  /// Scales a height value based on the screen's height relative to the design height.
  double get h => (this * MediaQueryData.fromView(WidgetsBinding.instance.window).size.height) / _designHeight;

  /// Scales a radius value based on the minimum of width and height scale factors.
  double get r {
    final mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    final scaleWidth = mediaQuery.size.width / _designWidth;
    final scaleHeight = mediaQuery.size.height / _designHeight;
    return this * (scaleWidth < scaleHeight ? scaleWidth : scaleHeight);
  }

  /// Scales a pixel value based on the screen's device pixel ratio.
  double get px => this / MediaQueryData.fromView(WidgetsBinding.instance.window).devicePixelRatio;

  /// Allows updating the reference design size if needed.
  static void setDesignSize({required double width, required double height}) {
    _designWidth = width;
    _designHeight = height;
  }
}

class Responsive {
  /// Initializes the responsive design with a custom design size.
  static void init(BuildContext context, {double designWidth = 375.0, double designHeight = 812.0}) {
    ResponsiveDimensions.setDesignSize(width: designWidth, height: designHeight);
  }
}
