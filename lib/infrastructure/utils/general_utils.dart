import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class GeneralUtils {
  GeneralUtils();

  static bool get _supportsNativeToast =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static Future<void> showToastMessage({
    required String toastMsg,
    Toast toastLength = Toast.LENGTH_SHORT,
    required bool isSuccess,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 1,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) {
    if (!_supportsNativeToast) {
      debugPrint('[Wallify] $toastMsg');
      return Future<void>.value();
    }

    return Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize ?? 14.px,
    ).then((_) {});
  }
}
