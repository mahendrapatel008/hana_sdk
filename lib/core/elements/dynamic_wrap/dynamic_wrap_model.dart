import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicWrapModel {
  final String? name;
  final WrapAlignment? alignment;
  final double? spacing;
  final double? runSpacing;
  final Axis? direction;
  final Clip? clipBehavior;
  final WrapCrossAlignment? crossAxisAlignment;
  final WrapAlignment? runAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final dynamic items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicWrapModel({
    this.name,
    this.alignment,
    this.spacing,
    this.runSpacing,
    this.direction,
    this.clipBehavior,
    this.crossAxisAlignment,
    this.runAlignment,
    this.textDirection,
    this.verticalDirection,
    this.items,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicWrapModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicWrapModel(
      name: json["name"],
      alignment: stringToWrapAlignment(json["alignment"]),
      spacing: json['spacing'] != null
          ? double.tryParse(json['spacing'].toString())
          : null,
      runSpacing: json['runSpacing'] != null
          ? double.tryParse(json['runSpacing'].toString())
          : null,
      direction: stringToAxis(json["direction"]),
      clipBehavior: stringToClip(json["clipBehavior"]),
      crossAxisAlignment:
          stringToWrapCrossAlignment(json["crossAxisAlignment"]),
      runAlignment: stringToWrapAlignment(json["runAlignment"]),
      textDirection: stringToTextDirection(json["textDirection"]),
      verticalDirection: stringToVerticalDirection(json["verticalDirection"]),
      isHideAndShow: json["isHideAndShow"],
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["alignment"] = alignment?.index; // Store index of WrapAlignment
    data["spacing"] = spacing;
    data["runSpacing"] = runSpacing;
    data["direction"] = direction?.index; // Store index of Axis
    data["clipBehavior"] = clipBehavior?.index; // Store index of Clip
    data["crossAxisAlignment"] =
        crossAxisAlignment?.index; // Store index of CrossAxisAlignment
    data["runAlignment"] = runAlignment?.index; // Store index of WrapAlignment
    data["textDirection"] =
        textDirection?.index; // Store index of TextDirection
    data["verticalDirection"] =
        verticalDirection?.index; // Store index of VerticalDirection
    data["items"] = items; // Serialize items

    return data;
  }
}
