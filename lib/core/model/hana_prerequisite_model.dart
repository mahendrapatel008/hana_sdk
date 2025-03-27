class HanaPrerequisiteModel {
  final String? id;
  final String? name;
  final String? value;
  final bool? isOtherRemove;
  final Map<String, dynamic>? style;

  HanaPrerequisiteModel({
    this.id,
    this.name,
    this.value,
    this.isOtherRemove,
    this.style,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'isOtherRemove': isOtherRemove,
      'style': style,
    };
  }

  factory HanaPrerequisiteModel.fromJson(Map<String, dynamic> json) {
    return HanaPrerequisiteModel(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      isOtherRemove: json['isOtherRemove'],
      style: json['style'],
    );
  }
}
