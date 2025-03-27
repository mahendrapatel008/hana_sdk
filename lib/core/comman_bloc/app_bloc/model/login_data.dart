class LoginData {
  final bool? success;
  final int? statusCode;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? userData;

  LoginData({
    this.success = false,
    this.message = 'Something went wrong...!!!',
    this.statusCode = 200,
    this.accessToken = '',
    this.refreshToken = '',
    this.userData,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    UserData? userData;
    if (json['user'] != null) {
      var margin = json["user"];
      userData = margin == null ? UserData() : UserData.fromJson(margin);
    }

    return LoginData(
      statusCode: json['statusCode'] ?? 200,
      success: json['success'] ?? false,
      message: json['message'] ?? 'Something went wrong...!!!',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userData: userData,
    );
  }
}

class UserData {
  final String? sId;
  final String? username;

  UserData({
    this.sId = '',
    this.username = '',
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      sId: json['_id'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
