import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class GradientModel {
  final String? type;
  final Alignment? begin; // for linear
  final Alignment? end; // for linear
  final Alignment? center; // for radial, sweep
  final double? radius; // for radial
  final double? startAngle; // for sweep
  final double? endAngle; // for sweep
  final List<Color?>? colors;

  GradientModel({
    this.type,
    this.begin,
    this.end,
    this.center,
    this.radius,
    this.startAngle,
    this.endAngle,
    this.colors,
  });

  factory GradientModel.fromJson(Map<String, dynamic> json) {
    var colors = (json['colors'] as List).map((sectionJson) {
      return hexToColor(sectionJson);
    }).toList();
    return GradientModel(
      type: json['type'] ?? 'linear',
      begin: stringToAlign(json['begin'] ?? 'topLeft'),
      end: stringToAlign(json['end'] ?? 'bottomRight'),
      center: stringToAlign(json['center'] ?? 'center'),
      radius: double.parse((json['radius'] ?? 0).toString()),
      startAngle: double.parse((json['startAngle'] ?? 0).toString()),
      endAngle: double.parse((json['endAngle'] ?? 0).toString()),
      colors: colors,
    );
  }
}
