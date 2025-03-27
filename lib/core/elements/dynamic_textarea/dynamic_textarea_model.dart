import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicTextAreaModel {
  final String? name;
  final String? id;
  final String? initialText;
  final Color? backGroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? placeholderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final double? shadowOffsetX;
  final double? shadowOffsetY;
  final int? borderWidth;
  final int? radius;
  final int? maxLength;
  final int? maxLines;
  final String? placeholder;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicTextAreaModel({
    this.name,
    this.id,
    this.initialText,
    this.backGroundColor,
    this.textColor,
    this.borderColor,
    this.focusBorderColor,
    this.placeholderColor,
    this.fontSize,
    this.fontWeight,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffsetX,
    this.shadowOffsetY,
    this.borderWidth,
    this.radius,
    this.maxLength,
    this.maxLines,
    this.placeholder,
    this.paddingVertical,
    this.paddingHorizontal,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicTextAreaModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicTextAreaModel(
      name: json['name'],
      id: json['id'],
      initialText: json['initialText'],
      backGroundColor: hexToColor(json['backGroundColor']),
      textColor: hexToColor(json['textColor']),
      borderColor: hexToColor(json['borderColor']),
      focusBorderColor: hexToColor(json['focusBorderColor']),
      placeholderColor: hexToColor(json['placeholderColor']),
      fontSize: json['fontSize']?.toDouble(),
      fontWeight:
          json['fontWeight'] == "bold" ? FontWeight.bold : FontWeight.normal,
      shadowColor: hexToColor(json['shadowColor']),
      shadowBlurRadius: json['shadowBlurRadius']?.toDouble(),
      shadowOffsetX: json['shadowOffsetX']?.toDouble(),
      shadowOffsetY: json['shadowOffsetY']?.toDouble(),
      borderWidth: json['borderWidth'],
      radius: json['radius'],
      maxLength: json['maxLength'],
      maxLines: json['maxLines'],
      placeholder: json['placeholder'],
      paddingVertical: json['paddingVertical']?.toDouble(),
      paddingHorizontal: json['paddingHorizontal']?.toDouble(),
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
