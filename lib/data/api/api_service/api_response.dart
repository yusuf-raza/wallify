import 'package:wallify/infrastructure/utils/logger_service.dart';

class ApiResponse {
  ApiResponse({this.success, this.data, this.message});

  factory ApiResponse.fromJson(dynamic json) {
    LoggerService.logFatal('ASD $json');
    final ApiResponse model = ApiResponse(
      success: json['success'] as bool?,
      data: json['data'],
      message: json['message'] as String? ?? '',
    );
    return model;
  }
  bool? success;
  dynamic data;
  String? message;
  Map<String, dynamic>? errors;
}
