class RadiusData {
  final int topLeft;
  final int topRight;
  final int bottomLeft;
  final int bottomRight;

  RadiusData({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'topLeft': topLeft,
      'topRight': topRight,
      'bottomLeft': bottomLeft,
      'bottomRight': bottomRight,
    };
  }

  factory RadiusData.fromJson(Map<String, dynamic> json) {
    return RadiusData(
      topLeft: json['topLeft'] ?? 0,
      topRight: json['topRight'] ?? 0,
      bottomLeft: json['bottomLeft'] ?? 0,
      bottomRight: json['bottomRight'] ?? 0,
    );
  }
}
