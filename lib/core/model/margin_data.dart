class MarginData {
  final int? left;
  final int? right;
  final int? top;
  final int? bottom;

  MarginData({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'right': right,
      'top': top,
      'bottom': bottom,
    };
  }

  factory MarginData.fromJson(Map<String, dynamic> json) {
    return MarginData(
      left: json['left'], // Provide a default value if null
      right: json['right'], // Provide a default value if null
      top: json['top'], // Provide a default value if null
      bottom: json['bottom'], // Provide a default boolean value
    );
  }
}
