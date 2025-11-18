class ApiResponse {
  ApiResponse({this.success, this.data, this.message});

  factory ApiResponse.fromJson(dynamic json) {
    final ApiResponse model = ApiResponse(
      success: json['success'] as bool?,
      data: json, // Assign the entire JSON object to data
      message: json['message'] as String? ?? '',
    );

    return model;
  }
  bool? success;
  dynamic data; // Changed to dynamic
  String? message;
  Map<String, dynamic>? errors;
}
