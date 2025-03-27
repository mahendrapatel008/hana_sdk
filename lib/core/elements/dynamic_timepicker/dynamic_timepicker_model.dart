import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicTimePickerModel {
  final String? name;
  final String? id;
  final Color? backGroundColor;
  final Color? textColor;
  final TimeOfDay? initialTime;
  final Color? borderColor;
  final int? borderWidth;
  final int? radius;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicTimePickerModel({
    this.name,
    this.id,
    this.backGroundColor,
    this.textColor,
    this.initialTime,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicTimePickerModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicTimePickerModel(
      name: json['name'],
      id: json['id'],
      backGroundColor: hexToColor(json['backGroundColor']),
      textColor: hexToColor(json['textColor']),
      borderColor: hexToColor(json['borderColor']),
      borderWidth: json['borderWidth'],
      radius: json['radius'],
      isHideAndShow: json["isHideAndShow"],
      initialTime: json['initialTime'] != null
          ? TimeOfDay(
              hour: int.parse(json['initialTime'].split(":")[0]),
              minute: int.parse(json['initialTime'].split(":")[1]),
            )
          : null,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
