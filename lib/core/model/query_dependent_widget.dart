class DependentInvisibleFields {
  final List<String> fieldNames;

  DependentInvisibleFields({
    required this.fieldNames,
  });

  // Factory constructor to create an object from JSON
  factory DependentInvisibleFields.fromJson(Map<String, dynamic> json) {
    return DependentInvisibleFields(
      fieldNames: List<String>.from(json['fieldName']),
    );
  }

  // Method to convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldNames,
    };
  }
}
