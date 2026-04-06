import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/general_utils.dart';
import 'package:wallify/infrastructure/utils/image_save_service.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

// This function runs in a separate isolate to prevent the main UI thread from blocking.
// It downloads the wallpaper image and sets it as the device wallpaper.
Future<void> _setWallpaperIsolate(Map<String, dynamic> args) async {
  final String imageUrl = args['imageUrl'];
  final int location = args['location'];
  final RootIsolateToken rootIsolateToken = args['token'];

  // Initialize the background isolate messenger.
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  final http.Response response = await http.get(Uri.parse(imageUrl));
  final Directory tempDir = await getTemporaryDirectory();
  final File file = await File('${tempDir.path}/wallpaper.jpg').writeAsBytes(response.bodyBytes);

  final WallpaperManagerFlutter wallpaperManager = WallpaperManagerFlutter();
  await wallpaperManager.setWallpaper(file, location);
}

class WallpaperDetailVM extends ChangeNotifier {
  final LoggerService _loggerService;
  static const String _albumName = 'wallify';

  WallpaperDetailVM({LoggerService? loggerService})
    : _loggerService = loggerService ?? LoggerService.instance;

  bool isDownloading = false;
  bool isSettingWallpaper = false;

  bool get canSetWallpaper => ImageSaveService.supportsWallpaperSetting;

  Future<void> showWallpaperSettingUnavailableMessage() async {
    await GeneralUtils.showToastMessage(
      toastMsg: AppStrings.wallpaperSettingNotSupported,
      isSuccess: false,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.red,
      textColor: AppColors.white,
    );
  }

  // Sets the wallpaper on the device.
  // This method uses the `compute` function to run the wallpaper setting logic in a separate isolate.
  // This is done to prevent the app from restarting, which can happen on some Android devices
  // due to memory pressure when setting a wallpaper.
  Future<void> setWallpaper(String imageUrl, int location) async {
    if (!canSetWallpaper) {
      await showWallpaperSettingUnavailableMessage();
      return;
    }

    isSettingWallpaper = true;
    notifyListeners();

    try {
      final RootIsolateToken? token = RootIsolateToken.instance;
      if (token == null) {
        _loggerService.logError('Failed to get root isolate token');
        return;
      }
      await compute(_setWallpaperIsolate, <String, Object>{
        'imageUrl': imageUrl,
        'location': location,
        'token': token,
      });

      await GeneralUtils.showToastMessage(
        toastMsg: AppStrings.wallpaperSetSuccessfully,
        isSuccess: true,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.green,
        textColor: AppColors.white,
      );
    } catch (e) {
      _loggerService.logError('Failed to set wallpaper: $e');
      await GeneralUtils.showToastMessage(
        toastMsg: AppStrings.failedToSetWallpaper,
        isSuccess: false,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
      );
    } finally {
      isSettingWallpaper = false;
      notifyListeners();
    }
  }

  Future<void> saveWallpaper(String imageUrl) async {
    isDownloading = true;
    notifyListeners();

    try {
      if (ImageSaveService.supportsGallerySaving) {
        final PermissionStatus status = await Permission.photos.request();
        if (!status.isGranted) {
          await GeneralUtils.showToastMessage(
            toastMsg: AppStrings.storagePermissionDenied,
            isSuccess: false,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
          );
          return;
        }

        final bool? result = await GallerySaver.saveImage(
          imageUrl,
          albumName: _albumName,
          toDcim: false,
        );

        await GeneralUtils.showToastMessage(
          toastMsg: result == true
              ? AppStrings.wallpaperSavedSuccessfully
              : AppStrings.failedToSaveWallpaper,
          isSuccess: result == true,
          backgroundColor: result == true ? AppColors.green : AppColors.red,
          textColor: AppColors.white,
        );
        return;
      }

      if (ImageSaveService.supportsLocalFileSaving) {
        final File savedFile = await ImageSaveService.saveImageLocally(imageUrl);
        await GeneralUtils.showToastMessage(
          toastMsg: AppStrings.wallpaperSavedToPath(savedFile.path),
          isSuccess: true,
          backgroundColor: AppColors.green,
          textColor: AppColors.white,
        );
        return;
      }

      await GeneralUtils.showToastMessage(
        toastMsg: AppStrings.wallpaperSavingNotSupported,
        isSuccess: false,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
      );
    } catch (e) {
      _loggerService.logError('failed to save $e');
      await GeneralUtils.showToastMessage(
        toastMsg: AppStrings.failedToSaveWallpaper,
        isSuccess: false,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
      );
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }
}
