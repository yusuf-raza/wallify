class ApiResponse {
  ApiResponse({this.success, this.data, this.message});

  factory ApiResponse.fromJson(dynamic json) {
    final ApiResponse model = ApiResponse(
      success: json['success'] as bool?,
      data: json['data'], // Safely cast to Map<String, dynamic>?
      message: json['message'] as String? ?? '',
    );

    return model;
  }
  bool? success;
  List<dynamic>? data; // Changed to List<dynamic>?
  String? message;
  Map<String, dynamic>? errors;
}
