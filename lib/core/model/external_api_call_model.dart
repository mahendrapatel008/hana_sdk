class ExternalApiCallModel {
  final String? id;
  final String? name;
  final String? url;
  final String? apiType;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? headers;
  final dynamic value;
  final Map<String, String>? saveToLocal;
  final List<String>? clearFromLocal;

  ExternalApiCallModel({
    this.id,
    this.name,
    this.url,
    this.apiType,
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
      'name': name,
      'url': url,
      'apiType': apiType,
      'body': body,
      'headers': headers,
      'value': value,
      'saveToLocal': saveToLocal,
      'clearFromLocal': clearFromLocal,
    };
  }

  /// Create an instance from JSON
  factory ExternalApiCallModel.fromJson(Map<String, dynamic> json) {
    return ExternalApiCallModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      apiType: json['apiType'] as String?,
      body: json['body'] != null
          ? Map<String, dynamic>.from(json['body'] as Map<String, dynamic>)
          : null,
      headers: json['headers'] != null
          ? Map<String, dynamic>.from(json['headers'] as Map<String, dynamic>)
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

  /// Create a copy of this instance with new values
  ExternalApiCallModel copyWith({
    String? id,
    String? name,
    String? url,
    String? apiType,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    dynamic value,
    Map<String, String>? saveToLocal,
    List<String>? clearFromLocal,
  }) {
    return ExternalApiCallModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      apiType: apiType ?? this.apiType,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      value: value ?? this.value,
      saveToLocal: saveToLocal ?? this.saveToLocal,
      clearFromLocal: clearFromLocal ?? this.clearFromLocal,
    );
  }

  /// Override toString() for easy debugging
  @override
  String toString() {
    return 'ExternalApiCallModel(id: $id, name: $name, url: $url, apiType: $apiType, body: $body, headers: $headers, value: $value, saveToLocal: $saveToLocal, clearFromLocal: $clearFromLocal)';
  }

  /// Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExternalApiCallModel &&
        other.id == id &&
        other.name == name &&
        other.url == url &&
        other.apiType == apiType &&
        other.body == body &&
        other.headers == headers &&
        other.value == value &&
        other.saveToLocal == saveToLocal &&
        other.clearFromLocal == clearFromLocal;
  }

  /// Override hashCode for object comparison
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        url.hashCode ^
        apiType.hashCode ^
        body.hashCode ^
        headers.hashCode ^
        value.hashCode ^
        saveToLocal.hashCode ^
        clearFromLocal.hashCode;
  }
}
