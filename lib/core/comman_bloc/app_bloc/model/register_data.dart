class RegisterData {
  final bool? success;
  final String? message;
  final String? token;

  RegisterData({
    this.success,
    this.message,
    this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Something went wrong...!!!',
      token: json['token'] ?? '',
    );
  }
}
