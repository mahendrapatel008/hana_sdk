import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicPopupModel {
  final String? title;
  final String? content;
  final String? name;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Color? backgroundColor;
  final double? borderRadius;
  final List<dynamic>? items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicPopupModel({
    this.title,
    this.content,
    this.name,
    this.confirmButtonText,
    this.cancelButtonText,
    this.backgroundColor,
    this.borderRadius,
    this.items,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicPopupModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicPopupModel(
      title: json['title'],
      content: json['content'],
      name: json['name'],
      confirmButtonText: json['confirmButtonText'],
      cancelButtonText: json['cancelButtonText'],
      backgroundColor: hexToColor(json['backgroundColor']),
      borderRadius: json['borderRadius']?.toDouble(),
      items: json.containsKey('items') ? json['items'] : null,
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  get buttonColor => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['name'] = name;
    data['confirmButtonText'] = confirmButtonText;
    data['cancelButtonText'] = cancelButtonText;
    data['backgroundColor'] = backgroundColor;
    data['borderRadius'] = borderRadius;
    data['items'] = items;
    return data;
  }
}
