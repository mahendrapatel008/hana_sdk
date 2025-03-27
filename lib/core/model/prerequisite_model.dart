class PrerequisiteModel {
  final String? id;
  final String? name;
  final String? value;
  final Map<String, dynamic>? data;

  PrerequisiteModel({
    this.id = '',
    this.name = '',
    this.value = '',
    this.data,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'data': data,
    };
  }

  factory PrerequisiteModel.fromJson(Map<String, dynamic> json) {
    return PrerequisiteModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      data: json['data'] ?? {},
    );
  }
}
