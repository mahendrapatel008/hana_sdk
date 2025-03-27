import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/common_model.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicDropdownModel {
  final String? id;
  final String? placeholder;
  final String? name;
  final String? dataKey;
  final int? radius, borderWidth;
  final List<CommonModel>? items;
  final Color? backGroundColor;
  final Color? borderColor;
  final Color? textColor;
  final int? textSize;
  final FontWeight? textWeight;
  final bool? required;
  final bool? isId;
  final bool? readOnly;
  final String? validator;
  final String? label;
  final bool? isHideAndShow;
  final OnClickData? onClickData;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicDropdownModel({
    this.id,
    this.placeholder,
    this.name,
    this.dataKey,
    this.backGroundColor,
    this.items,
    this.radius,
    this.borderWidth,
    this.borderColor,
    this.textColor,
    this.textSize,
    this.textWeight,
    this.required,
    this.validator,
    this.isId,
    this.readOnly,
    this.label,
    this.prerequisite,
    this.isHideAndShow,
    this.onClickData,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicDropdownModel.fromJson(Map<String, dynamic> json) {
    var formSections = json['items'] == null
        ? null
        : (json['items'] as List).map((sectionJson) {
            return CommonModel.fromJson(sectionJson);
          }).toList();

    OnClickData? onClickDataa;
    if (json['onClickData'] != null) {
      var margin = json["onClickData"];
      onClickDataa =
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
    // List<CommonModel> formSections = [];

    // if (json.containsKey('items') && json['items'] is List) {
    //   // Parse 'items' list if present
    //   formSections = (json['items'] as List).map((sectionJson) {
    //     return CommonModel.fromJson(sectionJson);
    //   }).toList();
    // } else if (json.containsKey('data') && json['data'] is List) {
    //   // If 'data' exists at the root level, handle it directly
    //   formSections.add(CommonModel(
    //     id: json['id'] ?? '1',
    //     name:json["name"] ?? "name"),
    //     prerequisite: (json['prerequisite'])
    //         .map((dataJson) => PrerequisiteModel.fromJson(dataJson)),
    //   );
    // }
    return DynamicDropdownModel(
      id: json["id"],
      placeholder: json["placeholder"],
      label: json["label"],
      name: json["name"],
      dataKey: json["dataKey"],
      radius: json["radius"],
      required: json["required"],
      validator: json["validator"],
      isId: json["isId"],
      readOnly: json["readOnly"],
      items: formSections,
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderWidth: json["borderWidth"],
      borderColor: hexToColor(json["borderColor"]),
      textColor: hexToColor(json["textColor"]),
      textSize: json["textSize"],
      textWeight: stringToFontWeight(
          json["textWeight"]), // Convert string to FontWeight
      isHideAndShow: json["isHideAndShow"],
      onClickData: onClickDataa,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
