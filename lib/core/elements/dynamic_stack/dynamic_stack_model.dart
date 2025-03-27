import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicStackModel {
  final List<dynamic> items; // To hold the list of widgets in the Stack
  final String? name;
  final AlignmentGeometry? alignment;
  final TextDirection? textDirection;
  final StackFit? stackFit;
  final Clip? clipBehavior;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicStackModel({
    required this.items,
    this.name,
    this.alignment,
    this.textDirection,
    this.stackFit,
    this.clipBehavior,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicStackModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicStackModel(
      name: json['name'],
      items: json['items'], // Handle dynamically built children
      alignment: stringToAlign(json['alignment']),
      textDirection: stringToTextDirection(json['textDirection']),
      stackFit: stringToStackFit(json['stackFit']),
      clipBehavior: stringToClip(json['clipBehavior']),
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['items'] = items;
    data['alignment'] = alignment;
    data['textDirection'] = textDirection;
    data['stackFit'] = stackFit;
    data['clipBehavior'] = clipBehavior;

    return data;
  }
}
