import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicDatePickerModel {
  final String? name;
  final String? id;
  final Color? backGroundColor;
  final Color? textColor;
  final String? dateFormat;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final Color? borderColor;
  final OnClickData? onClickData;
  final int? borderWidth;
  final int? radius;
  final bool? isMonth;
  final bool? isYear;
  final bool? readOnly;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicDatePickerModel({
    this.name,
    this.id,
    this.backGroundColor,
    this.textColor,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.borderColor,
    this.onClickData,
    this.borderWidth,
    this.radius,
    this.prerequisite,
    this.isHideAndShow,
    this.isMonth,
    this.isYear,
    this.readOnly,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicDatePickerModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicDatePickerModel(
      name: json['name'],
      id: json['id'],
      isHideAndShow: json["isHideAndShow"],
      isMonth: json["isMonth"],
      isYear: json["isYear"],
      readOnly: json["readOnly"],
      backGroundColor: hexToColor(json['backGroundColor']),
      textColor: hexToColor(json['textColor']),
      borderColor: hexToColor(json['borderColor']),
      borderWidth: json['borderWidth'],
      radius: json['radius'],
      dateFormat: json['dateFormat'],
      onClickData: onClickDataa,
      firstDate: json['firstDate'] != null
          ? json['firstDate'] == ''
              ? null
              : DateTime.parse(json['firstDate'])
          : null,
      lastDate: json['lastDate'] != null
          ? json['lastDate'] == ''
              ? null
              : DateTime.parse(json['lastDate'])
          : null,
      initialDate: json['initialDate'] != null
          ? json['initialDate'] == ''
              ? null
              : DateTime.parse(json['initialDate'])
          : null,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
