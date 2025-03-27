import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicButtonModel {
  final String? label;
  final String? name;
  final String? type;
  final int? width;
  final Color? color;
  final Color? titleColor;
  final int? fontSize;
  final int? height;
  final OnClickData? onClickData;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  const DynamicButtonModel({
    required this.label,
    this.name,
    required this.type,
    this.width,
    this.height,
    this.color,
    this.titleColor,
    this.fontSize,
    this.onClickData,
    this.prerequisite,
    this.isHideAndShow,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicButtonModel.fromJson(Map<String, dynamic> json) {
    OnClickData? onClickData;
    if (json['onClickData'] != null) {
      var margin = json["onClickData"];
      onClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
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
    return DynamicButtonModel(
      onClickData: onClickData,
      label: json["label"],
      name: json["name"],
      type: json["type"],
      width: json["width"],
      height: json["height"],
      fontSize: json["fontSize"],
      isHideAndShow: json["isHideAndShow"],
      color: hexToColor(json["color"]),
      titleColor: hexToColor(json["titleColor"]),
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
