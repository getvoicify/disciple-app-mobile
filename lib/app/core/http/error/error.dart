class ErrorData {
  final String? error;
  final bool? success;

  ErrorData({this.error, this.success});

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData(
    error: json['error'] as String?,
    success: json['success'] as bool? ?? false,
  );
}
