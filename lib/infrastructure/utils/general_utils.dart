import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class GeneralUtils {
  static Future<bool> isInternetAvailable({bool showToast = true}) async {
    try {
      // Check network connectivity
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        if (showToast) {
          GeneralUtils.showToast(
            toastMsg: 'No internet connection. Please check your WiFi or mobile data.',
            isSuccess: false,
          );
        }
        LoggerService.logError('No network connectivity');
        return false;
      }

      // Perform lightweight DNS lookup
      final List<InternetAddress> result = await InternetAddress.lookup(
        '1.1.1.1',
      ).timeout(const Duration(seconds: 3), onTimeout: () => <InternetAddress>[]);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        LoggerService.logInfo('DNS lookup successful for 1.1.1.1');
        return true;
      }

      if (showToast) {
        GeneralUtils.showToast(
          toastMsg: 'Internet connection is not working. Please try again later.',
          isSuccess: false,
        );
      }
      LoggerService.logError('DNS lookup failed');
      return false;
    } catch (e) {
      if (showToast) {
        GeneralUtils.showToast(
          toastMsg: 'Internet connection is not working. Please try again later.',
          isSuccess: false,
        );
      }
      LoggerService.logError('isInternetAvailable error: $e');
      return false;
    }
  }

  static void showToast({
    required String toastMsg,
    Toast toastLength = Toast.LENGTH_SHORT,
    required bool isSuccess,
  }) {
    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      //backgroundColor: isSuccess ? AppColors.bottomSheetBGColor : Colors.red,
      //textColor: themeController.secondaryColor.value,
      fontSize: 14.px,
    );
  }
}
