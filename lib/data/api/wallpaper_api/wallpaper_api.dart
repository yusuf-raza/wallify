import 'package:wallify/data/api/api_service/api_response.dart';
import 'package:wallify/data/api/api_service/api_wrapper.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/constants/app_endpoints.dart';

class WallpaperApi {
  late final ApiWrapper _apiWrapper;

  WallpaperApi() : _apiWrapper = ApiWrapper();

  Future<List<WallhavenWallpaper>> getWallpapers({int page = 1}) async {
    final Uri uri = Uri.parse(
      Endpoints.baseURL,
    ).replace(queryParameters: <String, String>{'page': page.toString()});

    final ApiResponse? response = await _apiWrapper.getApi(url: uri.toString());

    if (response == null) {
      throw Exception('Failed to load wallpapers');
    }

    if (response.data == null) {
      throw Exception('Failed to load wallpapers: data is null');
    }

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data.map((dynamic e) => WallhavenWallpaper.fromJson(e as Map<String, dynamic>)).toList();
  }
}
