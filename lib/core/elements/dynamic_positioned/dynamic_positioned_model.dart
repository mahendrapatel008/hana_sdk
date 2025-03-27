
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicPositionedModel {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? height;
  final double? width;
  final String? name;
  final dynamic items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicPositionedModel({
    this.items,
    this.top,
    this.bottom,
    this.right,
    this.left,
    this.height,
    this.width,
    this.name,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicPositionedModel.fromJson(Map<String, dynamic> json) {
    List<PrerequisiteModel>? prerequisiteList;
    if (json['prerequisite'] != null) {
      var prerequisites = json['prerequisite'] as List;
      prerequisiteList = prerequisites
          .map((item) => PrerequisiteModel.fromJson(item))
          .toList();
    }
    List<HanaPrerequisiteModel>? hanaPrerequisiteDesignList;
    if (json['hanaPrerequisiteDesign'] != null) {
      var hanaPrerequisiteDesigns = json['hanaPrerequisiteDesign'] as List;
      hanaPrerequisiteDesignList = hanaPrerequisiteDesigns
          .map((item) => HanaPrerequisiteModel.fromJson(item))
          .toList();
    }
    return DynamicPositionedModel(
      top: _parseDimension(json['top']),
      bottom: _parseDimension(json['bottom']),
      left: _parseDimension(json['left']),
      right: _parseDimension(json['right']),
      height: _parseDimension(json['height']),
      width: _parseDimension(json['width']),
      items: json.containsKey('items') ? json['items'] : null,
      prerequisite: prerequisiteList,
      name: json["name"],
      isHideAndShow: json["isHideAndShow"],
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['top'] = top;
    data['bottom'] = bottom;
    data['left'] = left;
    data['name'] = name;
    data['right'] = right;
    data['height'] = height;
    data['width'] = width;
    data['items'] = items;
    return data;
  }

  // Helper function to parse dimensions, supporting both percentage and fixed values
  static double? _parseDimension(dynamic value) {
    if (value == null) return null;
    if (value is String && value.endsWith('%')) {
      return double.parse(value.replaceAll('%', '')) / 100;
    } else {
      return double.tryParse(value.toString());
    }
  }
}
