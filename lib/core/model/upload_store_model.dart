class UploadAndStoreModel {
  bool? success;
  int? statusCode;
  String? message;
  String? filename;
  String? filePath;

  UploadAndStoreModel({
    this.success,
    this.message,
    this.filename,
    this.filePath,
    this.statusCode = 200,
  });

  UploadAndStoreModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'] ?? 200;
    message = json['message'];
    filename = json['filename'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['filename'] = filename;
    data['filePath'] = filePath;
    data['statusCode'] = statusCode;
    return data;
  }
}
