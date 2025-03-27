import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicRadioModel {
  final String? name;
  final int? radius;
  final List<String>? items;
  final Color? backGroundColor;
  final Color? borderColor;
  final int? borderWidth;
  final Color? textColor;
  final int? textSize;
  final FontWeight? textWeight;
  final Color? radioActiveColor;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicRadioModel({
    this.name,
    this.radius,
    this.items,
    this.backGroundColor,
    this.borderColor,
    this.borderWidth,
    this.textColor,
    this.textSize,
    this.textWeight,
    this.radioActiveColor,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicRadioModel.fromJson(Map<String, dynamic> json) {
    List<String>? stringItems;
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

    return DynamicRadioModel(
      name: json["name"],
      radius: json["radius"],
      items: stringItems,
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderColor: hexToColor(json["borderColor"]),
      borderWidth: json["borderWidth"],
      textColor: hexToColor(json["textColor"]),
      textSize: json["textSize"],
      textWeight: stringToFontWeight(json["textWeight"]),
      radioActiveColor: hexToColor(json["radioActiveColor"]),
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
