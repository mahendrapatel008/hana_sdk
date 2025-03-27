import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicTextModel {
  final String? label;
  final String? type;
  final String? id;
  final String? name;
  final String? dataKey;
  final bool? showLocation;
  final String? locationFormate;
  final String? addressFormate;
  final bool? showTime;
  final String? textAlign;
  final String? textColor;
  final String? fontWeight;
  final TextOverflow? overflow;
  final int? fontSize;
  final int? maxLines;
  final bool? softWrap;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicTextModel({
    required this.label,
    this.type,
    this.id,
    this.name,
    this.dataKey,
    this.showLocation,
    this.locationFormate,
    this.addressFormate,
    this.showTime,
    this.textAlign,
    this.textColor,
    this.fontWeight,
    this.fontSize,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'type': type,
      'id': id,
      'name': name,
      'dataKey': dataKey,
      'textAlign': textAlign,
      'locationFormate': locationFormate,
      'addressFormate': addressFormate,
      'showTime': showTime,
      'showLocation': showLocation,
      'textColor': textColor,
      'fontWeight': fontWeight,
      'overflow': overflow.toString().split('.').last, // Convert enum to string
      'fontSize': fontSize,
      'maxLines': maxLines,
      'softWrap': softWrap,
      'isHideAndShow': isHideAndShow,
      'prerequisite': prerequisite?.map((e) => e.toJson()).toList(),
      'hanaPrerequisiteDesign':
          hanaPrerequisiteDesign?.map((e) => e.toJson()).toList(),
    };
  }

  factory DynamicTextModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicTextModel(
      label: json["label"],
      type: json["type"],
      id: json["id"],
      name: json["name"],
      dataKey: json["dataKey"],
      locationFormate: json["locationFormate"],
      addressFormate: json["addressFormate"],
      showLocation: json["showLocation"],
      showTime: json["showTime"],
      isHideAndShow: json["isHideAndShow"],
      textAlign: json["textAlign"],
      overflow: stringToTextOverflow(json["overflow"]),
      textColor: json["textColor"],
      fontWeight: json["fontWeight"],
      fontSize: json["fontSize"],
      maxLines: json["maxLines"],
      softWrap: json["softWrap"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
