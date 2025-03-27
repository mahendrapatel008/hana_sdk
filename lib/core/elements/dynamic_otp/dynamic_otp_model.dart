import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicOtpViewModel {
  final int? numberOfFields;
  final String? name;
  final String? id;
  final double? borderWidth;
  final bool? showFieldAsBox;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final double? fieldWidth;
  final double? fieldHeight;
  final String? fontName;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? cursorColor;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicOtpViewModel({
    this.numberOfFields,
    this.borderWidth,
    this.showFieldAsBox,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.fieldWidth  ,
    this.fieldHeight,
    this.fontName,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.cursorColor,
    this.name,
    this.id,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicOtpViewModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicOtpViewModel(
      id: json["id"],
      name: json["name"],
      numberOfFields: json["numberOfFields"],
      borderWidth: json["borderWidth"]?.toDouble(),
      showFieldAsBox: json["showFieldAsBox"],
      borderColor: hexToColor(json["borderColor"]),
      focusedBorderColor: hexToColor(json["focusedBorderColor"]),
      fillColor: hexToColor(json["fillColor"]),
      fieldWidth: json["fieldWidth"]?.toDouble(),
      fieldHeight: json["fieldHeight"]?.toDouble(),
      fontName: json["fontName"],
      fontSize: json["fontSize"]?.toDouble(),
      fontWeight: stringToFontWeight(json["fontWeight"]),
      textColor: hexToColor(json["textColor"]),
      cursorColor: hexToColor(json["cursorColor"]),
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
