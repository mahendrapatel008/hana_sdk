class AttendenceModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final String? attendenceId;
  final String? accessToken;
  final String? refreshToken;
  final AttendenceModelData? userData;

  AttendenceModel({
    this.success = false,
    this.message = 'Something went wrong...!!!',
    this.statusCode = 200,
    this.attendenceId,
    this.accessToken = '',
    this.refreshToken = '',
    this.userData,
  });

  factory AttendenceModel.fromJson(Map<String, dynamic> json) {
    AttendenceModelData? userData;
    if (json['user'] != null) {
      var margin = json["user"];
      userData = margin == null
          ? AttendenceModelData()
          : AttendenceModelData.fromJson(margin);
    }

    return AttendenceModel(
      statusCode: json['statusCode'] ?? 200,
      success: json['success'] ?? false,
      message: json['message'] ?? 'Something went wrong...!!!',
      accessToken: json['accessToken'] ?? '',
      attendenceId: json['logEntry']['id'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userData: userData,
    );
  }
}

class AttendenceModelData {
  final String? sId;
  final String? username;

  AttendenceModelData({
    this.sId = '',
    this.username = '',
  });

  factory AttendenceModelData.fromJson(Map<String, dynamic> json) {
    return AttendenceModelData(
      sId: json['_id'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
