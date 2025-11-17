import 'package:wallify/data/api/api_service/api_response.dart';
import 'package:wallify/data/api/api_service/api_wrapper.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_endpoints.dart';

class WallpaperApi {
  ///gets user profile and returns UserProfile
  static Future<void> getWallpapers({
    required void Function(List<WallhavenWallpaper>) successCallback,
    required void Function(String error) failureCallback,
  }) async {
    await ApiWrapper().getApi(url: Endpoints.apiUrl).then((ApiResponse? response) {
      if (response == null) {
        failureCallback('API response is null.');
        return;
      }
      if (response.data == null) {
        failureCallback('API response data is null.');
        return;
      }
      final List<WallhavenWallpaper> wallpapers = (response.data as List<dynamic>)
          .map((e) => WallhavenWallpaper.fromJson(e as Map<String, dynamic>))
          .toList();
      successCallback(wallpapers);
    });
  }
}
