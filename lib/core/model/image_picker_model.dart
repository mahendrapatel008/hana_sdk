import 'dart:io';

class ImagePickerModel {
  final String? id; // Unique identifier
  final String? keyToStore; // Unique identifier
  final String? name; // Name of the API call
  final bool? isBase64; // Unique identifier
  final bool? openCamera;
  final bool? openGallery;
  final dynamic value; // Additional value or data
  final String? url; // Endpoint URL
  final File? file; // HTTP method (e.g., GET, POST)
  final Map<String, dynamic>? body; // Request body
  final Map<String, dynamic>? headers; // Request headers
  final Map<String, String>?
      saveToLocal; // Single map for saving to local storage
  final List<String>? clearFromLocal;

  ImagePickerModel({
    this.id,
    this.keyToStore,
    this.isBase64,
    this.openCamera,
    this.openGallery,
    this.name,
    this.url,
    this.file,
    this.body,
    this.headers,
    this.value,
    this.saveToLocal,
    this.clearFromLocal,
  });

  /// Convert the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyToStore': keyToStore,
      'isBase64': isBase64,
      'openCamera': openCamera,
      'openGallery': openGallery,
      'name': name,
      'url': url,
      'file': file,
      'body': body,
      'headers': headers,
      'value': value,
      'saveToLocal': saveToLocal, // Directly include saveToLocal
      'clearFromLocal': clearFromLocal,
    };
  }

  /// Create an instance from a JSON map
  factory ImagePickerModel.fromJson(Map<String, dynamic> json) {
    return ImagePickerModel(
      id: json['id'] as String?,
      keyToStore: json['keyToStore'] as String?,
      isBase64: json['isBase64'] as bool?,
      openCamera: json["openCamera"],
      openGallery: json["openGallery"],
      name: json['name'] as String?,
      url: json['url'] as String?,
      file: json['file'] as File?,
      body: json['body'] != null
          ? Map<String, dynamic>.from(json['body'] as Map)
          : null,
      headers: json['headers'] != null
          ? Map<String, dynamic>.from(json['headers'] as Map)
          : null,
      value: json['value'],
      saveToLocal: json['saveToLocal'] != null
          ? Map<String, String>.from(json['saveToLocal'] as Map)
          : null,
      clearFromLocal: json['clearFromLocal'] != null
          ? List<String>.from(json['clearFromLocal'] as List)
          : null,
    );
  }

  /// Creates a copy of the instance with modified fields
  ImagePickerModel copyWith({
    String? id,
    String? keyToStore,
    bool? isBase64,
    String? name,
    String? url,
    File? file,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    dynamic value,
    Map<String, String>? saveToLocal,
    List<String>? clearFromLocal,
  }) {
    return ImagePickerModel(
      id: id ?? this.id,
      keyToStore: keyToStore ?? this.keyToStore,
      isBase64: isBase64 ?? this.isBase64,
      name: name ?? this.name,
      url: url ?? this.url,
      file: file ?? this.file,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      value: value ?? this.value,
      saveToLocal: saveToLocal ?? this.saveToLocal,
      clearFromLocal: clearFromLocal ?? this.clearFromLocal,
    );
  }
}
