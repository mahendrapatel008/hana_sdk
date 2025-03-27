import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicCheckBoxModel {
  final String? name;
  final String? id;
  final int? radius;
  final List<String>? items;
  final Color? backGroundColor;
  final Color? borderColor;
  final int? borderWidth;
  final Color? textColor;
  final int? textSize;
  final FontWeight? textWeight;
  final Color? checkboxColor;
  final Color? checkTickColor;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicCheckBoxModel({
    this.name,
    this.id,
    this.radius,
    this.items,
    this.backGroundColor,
    this.borderColor,
    this.borderWidth,
    this.textColor,
    this.textSize,
    this.textWeight,
    this.checkboxColor,
    this.checkTickColor,
    this.prerequisite,
    this.isHideAndShow,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicCheckBoxModel.fromJson(Map<String, dynamic> json) {
    // Convert 'items' to a List<String> safely
    List<String>? stringItems = [];
    if (json['items'] != null && json['items'] is List) {
      stringItems =
          (json['items'] as List).map((item) => item.toString()).toList();
    }

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
    return DynamicCheckBoxModel(
      name: json["name"],
      id: json["id"],
      radius: json["radius"],
      isHideAndShow: json["isHideAndShow"],
      items: stringItems,
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderColor: hexToColor(json["borderColor"]),
      borderWidth: json["borderWidth"],
      textColor: hexToColor(json["textColor"]),
      textSize: json["textSize"],
      textWeight: stringToFontWeight(json["textWeight"]),
      checkboxColor: hexToColor(json["checkboxColor"]),
      checkTickColor: hexToColor(json["checkTickColor"]),
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
