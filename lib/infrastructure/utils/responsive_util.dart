import 'package:flutter/material.dart';

extension ResponsiveDimensions on num {
  static double _designWidth = 375.0; // Reference design width (e.g., iPhone 11)
  static double _designHeight = 812.0; // Reference design height (e.g., iPhone 11)

  /// Scales a width value based on the screen's width relative to the design width.
  double get w =>
      (this * MediaQueryData.fromView(WidgetsBinding.instance.window).size.width) / _designWidth;

  /// Scales a height value based on the screen's height relative to the design height.
  double get h =>
      (this * MediaQueryData.fromView(WidgetsBinding.instance.window).size.height) / _designHeight;

  /// Scales a radius value based on the minimum of width and height scale factors.
  double get r {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    final double scaleWidth = mediaQuery.size.width / _designWidth;
    final double scaleHeight = mediaQuery.size.height / _designHeight;
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
  static void init(
    BuildContext context, {
    double designWidth = 375.0,
    double designHeight = 812.0,
  }) {
    ResponsiveDimensions.setDesignSize(width: designWidth, height: designHeight);
  }
}

class ResponsiveBreakpoints {
  static const double tablet = 768;
  static const double desktop = 1100;
  static const double wideDesktop = 1440;
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isTablet => screenSize.width >= ResponsiveBreakpoints.tablet;
  bool get isDesktop => screenSize.width >= ResponsiveBreakpoints.desktop;
  bool get isWideDesktop => screenSize.width >= ResponsiveBreakpoints.wideDesktop;

  double get contentHorizontalPadding {
    if (isWideDesktop) return 40;
    if (isDesktop) return 28;
    if (isTablet) return 20;
    return 12;
  }

  double get contentMaxWidth {
    if (isWideDesktop) return 1600;
    if (isDesktop) return 1280;
    if (isTablet) return 960;
    return screenSize.width;
  }
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final double resolvedMaxWidth = maxWidth ?? context.contentMaxWidth;
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? EdgeInsets.symmetric(horizontal: context.contentHorizontalPadding);

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
        child: Padding(
          padding: resolvedPadding,
          child: child,
        ),
      ),
    );
  }
}
