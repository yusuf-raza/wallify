import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wallify/data/api/api_service/api_response.dart';
import 'package:wallify/infrastructure/utils/connectivity_checker.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

class ApiWrapper {
  final JsonDecoder _decoder = const JsonDecoder();
  final http.Client _client;
  final ConnectivityChecker _connectivityChecker;
  final LoggerService _loggerService;

  ApiWrapper({
    http.Client? client,
    ConnectivityChecker? connectivityChecker,
    LoggerService? loggerService,
  }) : _client = client ?? http.Client(),
       _connectivityChecker = connectivityChecker ?? ConnectivityCheckerImpl(),
       _loggerService = loggerService ?? LoggerService.instance;

  static const Duration _requestTimeout = Duration(seconds: 30);
  static const Map<String, String> _jsonHeaders = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<ApiResponse?> getApi({required String url}) async {
    try {
      final String urlString = url;

      _loggerService.logFatal('URL $urlString');

      if (!await _connectivityChecker.isInternetAvailable()) {
        _loggerService.logError('No active internet connection.');
        return null;
      }

      final http.Response response = await _client
          .get(Uri.parse(urlString), headers: _jsonHeaders)
          .timeout(_requestTimeout);

      _loggerService.logInfo(
        'URL $url\nstatus code ${response.statusCode}\nResponse getApi: ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> data = _decoder.convert(response.body) as Map<String, dynamic>;
          return ApiResponse.fromJson(data);
        } catch (e) {
          _loggerService.logError('getApi Failed to parse response: $e');
          return ApiResponse(success: false, message: 'Failed to parse API response.');
        }
      } else if (response.statusCode == 404) {
        _loggerService.logError('getApi Resource not found: $urlString');
        return ApiResponse(success: false, message: 'Resource not found.');
      } else {
        _loggerService.logError('getApi API error: $urlString, status=${response.statusCode}');
        return ApiResponse(
          success: false,
          message: 'API error with status code ${response.statusCode}.',
        );
      }
    } catch (e) {
      _loggerService.logError('Error in getApi: $e');
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  Future<ApiResponse> postApi({required String url, required Map<String, dynamic> param}) async {
    final String urlString = url;
    final Uri? uri = Uri.tryParse(urlString);
    if (uri == null) {
      _loggerService.logError('postApi Invalid URL: $urlString');
      return ApiResponse(success: false);
    }

    if (!await _connectivityChecker.isInternetAvailable()) {
      _loggerService.logError('postApi No internet connection');
      return ApiResponse(success: false);
    }

    String? body;
    try {
      body = jsonEncode(param);
    } catch (e) {
      _loggerService.logError('postApi Failed to encode parameters: $e');
      return ApiResponse(success: false);
    }

    try {
      final http.Response response = await _client
          .post(uri, body: body, headers: _jsonHeaders)
          .timeout(_requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
          _loggerService.logInfo('Response for $url\nMethod POST \n$data');
          return ApiResponse.fromJson(data);
        } catch (e) {
          _loggerService.logError('postApi Failed to parse response: $e');
          return ApiResponse(success: false);
        }
      } else if (response.statusCode == 404) {
        _loggerService.logError('postApi Resource not found: $urlString');
        return ApiResponse(success: false);
      } else {
        _loggerService.logError('postApi API error: $urlString, status=${response.statusCode}');
        return ApiResponse(success: false);
      }
    } catch (e) {
      _loggerService.logError('postApi Network error in postApi: $e');
      return ApiResponse(success: false);
    }
  }

  Future<ApiResponse> deleteApi({required String url}) async {
    final String urlString = url;
    final Uri? uri = Uri.tryParse(urlString);
    if (uri == null) {
      _loggerService.logError('deleteApi Invalid URL: $urlString');
      return ApiResponse(success: false);
    }

    if (!await _connectivityChecker.isInternetAvailable()) {
      _loggerService.logError('deleteApi No internet connection');
      return ApiResponse(success: false);
    }

    try {
      final http.Response response = await _client
          .delete(uri, headers: _jsonHeaders)
          .timeout(_requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
          _loggerService.logInfo('Response for $url\nMethod DELETE\n$data');
          return ApiResponse.fromJson(data);
        } catch (e) {
          _loggerService.logError('deleteApi Failed to parse response: $e');
          return ApiResponse(success: false);
        }
      } else if (response.statusCode == 404) {
        _loggerService.logError('Resource not found: $urlString');
        return ApiResponse(success: false);
      } else {
        _loggerService.logError('deleteApi API error: $urlString, status=${response.statusCode}');
        return ApiResponse(success: false);
      }
    } catch (e) {
      _loggerService.logError('deleteApi Network error in deleteApi: $e');
      return ApiResponse(success: false);
    }
  }

  Future<ApiResponse> multipartPost(
    String url, {
    required Map<String, String> fields,
    Map<String, File>? files,
  }) async {
    final String urlString = url;
    final Uri? uri = Uri.tryParse(urlString);
    if (uri == null) {
      _loggerService.logError('multipartPost Invalid URL: $urlString');
      return ApiResponse(success: false);
    }

    if (!await _connectivityChecker.isInternetAvailable()) {
      _loggerService.logError('multipartPost No internet connection');
      return ApiResponse(success: false);
    }

    final http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields.addAll(fields);

    if (files != null) {
      try {
        for (final MapEntry<String, File> entry in files.entries) {
          final File file = entry.value;
          if (!file.existsSync()) {
            _loggerService.logError('multipartPost File not found: ${file.path}');
            return ApiResponse(success: false);
          }
          request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
        }
      } catch (e) {
        _loggerService.logError('multipartPost Failed to process files: $e');
        return ApiResponse(success: false);
      }
    }

    try {
      final http.StreamedResponse streamedResponse = await request.send().timeout(_requestTimeout);
      final http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
          _loggerService.logInfo('Response for $url\nMethod POST - MULTIPART\n$data');
          return ApiResponse.fromJson(data);
        } catch (e) {
          _loggerService.logError('multipartPost Failed to parse response: $e');
          return ApiResponse(success: false);
        }
      } else if (response.statusCode == 404) {
        _loggerService.logError('multipartPost Resource not found: $urlString');
        return ApiResponse(success: false);
      } else {
        _loggerService.logError(
          'multipartPost API error: $urlString, status=${response.statusCode}',
        );
        return ApiResponse(success: false);
      }
    } catch (e) {
      _loggerService.logError('multipartPost Network error in multipartPost: $e');
      return ApiResponse(success: false);
    }
  }
}
