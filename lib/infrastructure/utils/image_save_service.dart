import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageSaveService {
  ImageSaveService._();

  static bool get supportsWallpaperSetting =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get supportsGallerySaving =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get supportsLocalFileSaving =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  static Future<File> saveImageLocally(String imageUrl, {String fileNamePrefix = 'wallify_'}) async {
    final Uri uri = Uri.parse(imageUrl);
    final http.Response response = await http.get(uri);
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Image download failed with status ${response.statusCode}');
    }

    final Directory directory = await _resolveTargetDirectory();
    await directory.create(recursive: true);

    final String extension = _resolveFileExtension(uri);
    final String fileName = '${fileNamePrefix}${DateTime.now().millisecondsSinceEpoch}.$extension';
    final File file = File('${directory.path}/$fileName');
    return file.writeAsBytes(response.bodyBytes);
  }

  static Future<Directory> _resolveTargetDirectory() async {
    final Directory? downloadsDirectory = await getDownloadsDirectory();
    if (downloadsDirectory != null) {
      return Directory('${downloadsDirectory.path}/Wallify');
    }

    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return Directory('${documentsDirectory.path}/Wallify');
  }

  static String _resolveFileExtension(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return 'jpg';
    }
    final String fileName = uri.pathSegments.last;
    final int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) {
      return 'jpg';
    }
    final String extension = fileName.substring(dotIndex + 1).toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return extension;
      default:
        return 'jpg';
    }
  }
}
