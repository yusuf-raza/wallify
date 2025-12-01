import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/presentation/wallpaper_detail/slider_item.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperDetailViewModel extends ChangeNotifier {
  final LoggerService _loggerService;

  WallpaperDetailViewModel({LoggerService? loggerService})
    : _loggerService = loggerService ?? LoggerService.instance {
    imageSliders = List<Widget>.generate(imgList.length, (int index) {
      return SliderItem(index: index, imgList: imgList);
    });
  }

  final List<String> imgList = <String>[
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  ];

  late final List<Widget> imageSliders;
  bool isDownloading = false;

  Future<void> downloadAndSetWallpaper(String imageUrl) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Directory tempDir = await getTemporaryDirectory();
      final File file = await File(
        '${tempDir.path}/wallpaper.jpg',
      ).writeAsBytes(response.bodyBytes);

      final WallpaperManagerFlutter wallpaperManager = WallpaperManagerFlutter();
      await wallpaperManager.setWallpaper(file.path, WallpaperManagerFlutter.homeScreen);

      Fluttertoast.showToast(
        msg: 'Wallpaper set successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to set wallpaper.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> saveWallpaper(String imageUrl) async {
    isDownloading = true;
    notifyListeners();

    try {
      final PermissionStatus status = await Permission.photos.request();
      if (status.isGranted) {
        final http.Response response = await http.get(Uri.parse(imageUrl));
        final Uint8List bytes = response.bodyBytes;
        await ImageGallerySaverPlus.saveImage(bytes);

        Fluttertoast.showToast(
          msg: 'Wallpaper saved successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Storage permission denied.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      _loggerService.logError('failed to save $e');
      Fluttertoast.showToast(
        msg: 'Failed to save wallpaper.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }
}
