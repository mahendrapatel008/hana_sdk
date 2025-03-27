class DynamicData {
  final dynamic dynamicData;

  DynamicData({
    required this.dynamicData,
  });

  Map<String, dynamic> toJson() {
    if (dynamicData is Map<String, dynamic>) {
      return dynamicData;
    } else if (dynamicData is List) {
      return {
        "data": dynamicData
      };
    }
    return {};
  }

  factory DynamicData.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return DynamicData(dynamicData: json);
    } else if (json is List) {
      return DynamicData(dynamicData: json);
    } else {
      throw Exception("Invalid JSON type: ${json.runtimeType}");
    }
  }
}
