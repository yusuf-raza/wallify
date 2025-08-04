import 'package:wallify/data/api/api_service/api_response.dart';
import 'package:wallify/data/api/api_service/api_wrapper.dart';
import 'package:wallify/data/models/wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_endpoints.dart';

class WallpaperApi {
  ///gets user profile and returns UserProfile
  static Future<void> getWallpapers({
    required void Function(Wallpaper) successCallback,
    required void Function(String error) failureCallback,
  }) async {
    await ApiWrapper().getApi(url: Endpoints.apiUrl).then((ApiResponse? response) {
      final Wallpaper wallpaper = Wallpaper.fromJson(response!.data as Map<String, dynamic>);
      successCallback(wallpaper);
      // if (response!.success!) {
      //   final Wallpaper wallpaper = Wallpaper.fromJson(response.data as Map<String, dynamic>);
      //   successCallback(wallpaper);
      // } else {
      //   final String error = response.data['error'] as String;
      //   failureCallback(error);
      //   LoggerService.logError('getUserProfileApi $error');
      // }
    });
  }
}
