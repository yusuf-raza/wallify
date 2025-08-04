// import 'dart:convert';
// import 'dart:io';
//
// import 'package:bizvid_flutter/data/api/api_service/api_response.dart';
// import 'package:bizvid_flutter/data/services/shared_preferences_service.dart';
// import 'package:bizvid_flutter/infrastructure/constants/app_endpoints.dart';
// import 'package:bizvid_flutter/infrastructure/utils/logger_util.dart';
// import 'package:bizvid_flutter/infrastructure/utils/utils.dart';
// import 'package:http/http.dart' as http;
//
// class ApiWrapper {
//   static const Duration _requestTimeout = Duration(seconds: 30);
//   static const Map<String, String> _jsonHeaders = <String, String>{
//     'Content-Type': 'application/json',
//   };
//
//   Future<ApiResponse> postApiWithoutToken({
//     required String url,
//     required Map<String, dynamic> param,
//   }) async {
//     // Step 1: Construct and validate URL
//     final String urlString = '${Endpoints.baseUrl}$url';
//     final Uri? uri = Uri.tryParse(urlString);
//     if (uri == null) {
//       LogUtil.logError('postApiWithoutToken Invalid URL: $urlString');
//       return ApiResponse(success: false);
//     }
//
//     // Step 2: Check internet connectivity
//     if (!await Utilities.isInternetAvailable()) {
//       LogUtil.logError('postApiWithoutToken No internet connection');
//       return ApiResponse(success: false);
//     }
//
//     // Step 3: Validate and encode parameters
//     String? body;
//     try {
//       body = jsonEncode(param);
//     } catch (e) {
//       LogUtil.logError('postApiWithoutToken Failed to encode parameters: $e');
//       return ApiResponse(success: false);
//     }
//
//     // Step 4: Make the API call
//     try {
//       final http.Response response = await http
//           .post(uri, body: body, headers: _jsonHeaders)
//           .timeout(_requestTimeout);
//
//       // Step 5: Handle response based on status code
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
//           LogUtil.logInfo('Response for $url\nMethod POST WITHOUT TOKEN\n$data');
//           return ApiResponse.fromJson(data);
//         } catch (e) {
//           LogUtil.logError('postApiWithoutToken Failed to parse response: $e');
//           return ApiResponse(success: false);
//         }
//       } else if (response.statusCode == 404) {
//         LogUtil.logError('postApiWithoutToken Resource not found: $urlString');
//         return ApiResponse(success: false);
//       } else {
//         final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
//         LogUtil.logError('postApiWithoutToken API error: $urlString, status=${data}');
//         return ApiResponse.fromJson(data);
//       }
//     } catch (e) {
//       LogUtil.logError('postApiWithoutToken Network error in postApiWithoutToken: $e');
//       return ApiResponse(success: false);
//     }
//   }
//
//   Future<ApiResponse> postApi({required String url, required Map<String, dynamic> param}) async {
//     // Step 1: Retrieve auth token
//     final String? authKey = await SharedPrefs().getAuthToken();
//     if (authKey == null) {
//       LogUtil.logError('postApi Auth token is missing');
//       return ApiResponse(success: false);
//     }
//
//     // Step 2: Construct and validate URL
//     final String urlString = '${Endpoints.baseUrl}$url';
//     final Uri? uri = Uri.tryParse(urlString);
//     if (uri == null) {
//       LogUtil.logError('postApi Invalid URL: $urlString');
//       return ApiResponse(success: false);
//     }
//
//     // Step 3: Check internet connectivity
//     if (!await Utilities.isInternetAvailable()) {
//       LogUtil.logError('postApi No internet connection');
//       return ApiResponse(success: false);
//     }
//
//     // Step 4: Validate and encode parameters
//     String? body;
//     try {
//       body = jsonEncode(param);
//     } catch (e) {
//       LogUtil.logError('postApi Failed to encode parameters: $e');
//       return ApiResponse(success: false);
//     }
//
//     // Step 5: Make the API call
//     try {
//       final http.Response response = await http
//           .post(
//             uri,
//             body: body,
//             headers: <String, String>{..._jsonHeaders, 'Authorization': 'Bearer $authKey'},
//           )
//           .timeout(_requestTimeout);
//
//       // Step 6: Handle response based on status code
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
//           LogUtil.logInfo('Response for $url\nMethod POST \n$data');
//           return ApiResponse.fromJson(data);
//         } catch (e) {
//           LogUtil.logError('postApi Failed to parse response: $e');
//           return ApiResponse(success: false);
//         }
//       } else if (response.statusCode == 404) {
//         LogUtil.logError('postApi Resource not found: $urlString');
//         return ApiResponse(success: false);
//       } else if (response.statusCode == 401) {
//         LogUtil.logError('postApi Unauthorized: Invalid or expired token for $urlString');
//         return ApiResponse(success: false);
//       } else {
//         LogUtil.logError('postApi API error: $urlString, status=${response.statusCode}');
//         return ApiResponse(success: false);
//       }
//     } catch (e) {
//       LogUtil.logError('postApi Network error in postApi: $e');
//       return ApiResponse(success: false);
//     }
//   }
//
//   Future<ApiResponse> getApi({required String url}) async {
//     // Step 1: Retrieve auth token
//     final String? authKey = await SharedPrefs().getAuthToken();
//     if (authKey == null) {
//       LogUtil.logError('getApi Auth token is missing');
//       return ApiResponse(success: false);
//     }
//
//     // Step 2: Construct and validate URL
//     final String urlString = '${Endpoints.baseUrl}$url';
//     final Uri? uri = Uri.tryParse(urlString);
//     if (uri == null) {
//       LogUtil.logError('getApi Invalid URL: $urlString');
//       return ApiResponse(success: false);
//     }
//
//     // Step 3: Check internet connectivity
//     if (!await Utilities.isInternetAvailable()) {
//       LogUtil.logError('getApi No internet connection');
//       return ApiResponse(success: false);
//     }
//
//     // Step 4: Make the API call
//     try {
//       final http.Response response = await http
//           .get(uri, headers: <String, String>{..._jsonHeaders, 'Authorization': 'Bearer $authKey'})
//           .timeout(_requestTimeout);
//
//       // Step 5: Handle response based on status code
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
//           LogUtil.logInfo('Response for $url\nMethod GET \n$data');
//           return ApiResponse.fromJson(data);
//         } catch (e) {
//           LogUtil.logError('getApi Failed to parse response: $e');
//           return ApiResponse(success: false);
//         }
//       } else if (response.statusCode == 404) {
//         LogUtil.logError('getApi Resource not found: $urlString');
//         return ApiResponse(success: false);
//       } else if (response.statusCode == 401) {
//         LogUtil.logError('getApi Unauthorized: Invalid or expired token for $urlString');
//         return ApiResponse(success: false);
//       } else {
//         LogUtil.logError('getApi API error: $urlString, status=${response.statusCode}');
//         return ApiResponse(success: false);
//       }
//     } catch (e) {
//       LogUtil.logError('getApi Network error in getApi: $e');
//       return ApiResponse(success: false);
//     }
//   }
//
//   Future<ApiResponse> deleteApi({required String url}) async {
//     // Step 1: Retrieve auth token
//     final String? authKey = await SharedPrefs().getAuthToken();
//     if (authKey == null) {
//       LogUtil.logError('deleteApi Auth token is missing');
//       return ApiResponse(success: false);
//     }
//
//     // Step 2: Construct and validate URL
//     final String urlString = '${Endpoints.baseUrl}$url';
//     final Uri? uri = Uri.tryParse(urlString);
//     if (uri == null) {
//       LogUtil.logError('deleteApi Invalid URL: $urlString');
//       return ApiResponse(success: false);
//     }
//
//     // Step 3: Check internet connectivity
//     if (!await Utilities.isInternetAvailable()) {
//       LogUtil.logError('deleteApi No internet connection');
//       return ApiResponse(success: false);
//     }
//
//     // Step 4: Make the API call
//     try {
//       final http.Response response = await http
//           .delete(
//             uri,
//             headers: <String, String>{..._jsonHeaders, 'Authorization': 'Bearer $authKey'},
//           )
//           .timeout(_requestTimeout);
//
//       // Step 5: Handle response based on status code
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
//           LogUtil.logInfo('Response for $url\nMethod DELETE\n$data');
//           return ApiResponse.fromJson(data);
//         } catch (e) {
//           LogUtil.logError('deleteApi Failed to parse response: $e');
//           return ApiResponse(success: false);
//         }
//       } else if (response.statusCode == 404) {
//         LogUtil.logError('Resource not found: $urlString');
//         return ApiResponse(success: false);
//       } else if (response.statusCode == 401) {
//         LogUtil.logError('deleteApi Unauthorized: Invalid or expired token for $urlString');
//         return ApiResponse(success: false);
//       } else {
//         LogUtil.logError('deleteApi API error: $urlString, status=${response.statusCode}');
//         return ApiResponse(success: false);
//       }
//     } catch (e) {
//       LogUtil.logError('deleteApi Network error in deleteApi: $e');
//       return ApiResponse(success: false);
//     }
//   }
//
//   Future<ApiResponse> multipartPost(
//     String url, {
//     required Map<String, String> fields,
//     Map<String, File>? files,
//     bool auth = true,
//   }) async {
//     // Step 1: Retrieve auth token if required
//     String? authKey;
//     if (auth) {
//       authKey = await SharedPrefs().getAuthToken();
//       LogUtil.logFatal('$authKey');
//
//       if (authKey == null) {
//         LogUtil.logError('multipartPost Auth token is missing');
//         return ApiResponse(success: false);
//       }
//     }
//
//     // Step 2: Construct and validate URL
//     final String urlString = '${Endpoints.baseUrl}$url';
//     final Uri? uri = Uri.tryParse(urlString);
//     if (uri == null) {
//       LogUtil.logError('multipartPost Invalid URL: $urlString');
//       return ApiResponse(success: false);
//     }
//
//     // Step 3: Check internet connectivity
//     if (!await Utilities.isInternetAvailable()) {
//       LogUtil.logError('multipartPost No internet connection');
//       return ApiResponse(success: false);
//     }
//
//     // Step 4: Prepare multipart request
//     final http.MultipartRequest request = http.MultipartRequest('POST', uri);
//     if (authKey != null) {
//       request.headers['Authorization'] = 'Bearer $authKey';
//     }
//     request.headers['Content-Type'] = 'multipart/form-data';
//     request.fields.addAll(fields);
//
//     // Step 5: Add files to the request
//     if (files != null) {
//       try {
//         for (final MapEntry<String, File> entry in files.entries) {
//           final File file = entry.value;
//           if (!file.existsSync()) {
//             LogUtil.logError('multipartPost File not found: ${file.path}');
//             return ApiResponse(success: false);
//           }
//           request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
//         }
//       } catch (e) {
//         LogUtil.logError('multipartPost Failed to process files: $e');
//         return ApiResponse(success: false);
//       }
//     }
//
//     // Step 6: Send the request
//     try {
//       final http.StreamedResponse streamedResponse = await request.send().timeout(_requestTimeout);
//       final http.Response response = await http.Response.fromStream(streamedResponse);
//
//       // Step 7: Handle response based on status code
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
//           LogUtil.logInfo('Response for $url\nMethod POST - MULTIPART\n$data');
//           return ApiResponse.fromJson(data);
//         } catch (e) {
//           LogUtil.logError('multipartPost Failed to parse response: $e');
//           return ApiResponse(success: false);
//         }
//       } else if (response.statusCode == 404) {
//         LogUtil.logError('multipartPost Resource not found: $urlString');
//         return ApiResponse(success: false);
//       } else if (response.statusCode == 401) {
//         LogUtil.logError('multipartPost Unauthorized: Invalid or expired token for $urlString');
//         return ApiResponse(success: false);
//       } else {
//         LogUtil.logError('multipartPost API error: $urlString, status=${response.statusCode}');
//         return ApiResponse(success: false);
//       }
//     } catch (e) {
//       LogUtil.logError('multipartPost Network error in multipartPost: $e');
//       return ApiResponse(success: false);
//     }
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallify/data/api/api_service/api_response.dart';
import 'package:wallify/infrastructure/constants/app_endpoints.dart';
import 'package:wallify/infrastructure/utils/general_utils.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

class ApiWrapper {
  final JsonDecoder _decoder = const JsonDecoder();

  Future<ApiResponse?> getApi({required String url}) async {
    try {
      //final String? authKey = await SharedPrefs().getAuthToken();

      final String urlString = '${Endpoints.baseURL}$url';

      LoggerService.logFatal('URL $urlString');

      // Step 2: Verify active internet access
      if (!await GeneralUtils.isInternetAvailable()) {
        LoggerService.logError('No active internet connection.');
        return null;
      }

      // Step 3: Perform HTTP GET request
      final http.Response response = await http.get(
        Uri.parse(urlString),
        headers: <String, String>{
          'Authorization': '${Endpoints.apiKey}',
          'Content-Type': 'application/json',
        },
      );

      LoggerService.logFatal('${response.body}');

      // Step 4: Log and parse the response
      LoggerService.logInfo(
        'URL $url\nstatus code ${response.statusCode}\nResponse getApi: ${response.body}',
      );
      final Map<String, dynamic> data = _decoder.convert(response.body) as Map<String, dynamic>;
      return ApiResponse.fromJson(data);
    } catch (e) {
      LoggerService.logError('Error in getApi: $e');
      return null;
    }
  }
}
