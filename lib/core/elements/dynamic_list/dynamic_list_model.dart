import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicListModel {
  final String type;
  final int? height;
  final String? name;
  final String? dataKey;
  final String? id;
  final String? label;
  final dynamic items;
  final List<dynamic>? item;
  final Axis? scrollDirection;
  final OnClickData? onClickData;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicListModel({
    required this.type,
    required this.id,
    required this.label,
    required this.name,
    required this.height,
    required this.items,
    required this.item,
    required this.scrollDirection,
    required this.onClickData,
    this.isHideAndShow,
    this.dataKey,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicListModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicListModel(
      type: json["type"],
      id: json["id"],
      label: json["label"],
      dataKey: json["dataKey"],
      name: json["name"],
      height: json["height"],
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      item: json.containsKey('item')
          ? json['item']
          : [], // Handle missing 'items' field
      scrollDirection: stringToAxis(json["scrollDirection"]),
      isHideAndShow: json["isHideAndShow"],
      onClickData: onClickData,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
