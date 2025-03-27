import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicPopupMenuModel {
  final double? height;
  final double? width;
  final String? name;
  final String? id;
  final String? label;
  final BoxFit? fit;
  final int? radius;
  final Color? borderColor;
  final bool? showBorder;
  final int? borderWidth;
  final Color? backGroundColor;
  final String? textColorLabel;
  final String? fontWeightLabel;
  final int? fontSizeLabel;
  final String? textColorSublabel;
  final String? fontWeightSublabel;
  final int? fontSizeSublabel;
  final dynamic item;
  final bool? isHideAndShow;
  final List<DynamicPopupMenuItem>? popupMenuItems;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicPopupMenuModel({
    this.id,
    this.label,
    this.name,
    this.height,
    this.width,
    this.radius,
    this.backGroundColor,
    this.borderColor,
    this.borderWidth,
    this.showBorder,
    this.textColorLabel,
    this.fontWeightLabel,
    this.fontSizeLabel,
    this.textColorSublabel,
    this.fontWeightSublabel,
    this.fontSizeSublabel,
    required this.item,
    this.fit,
    this.isHideAndShow,
    this.popupMenuItems,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicPopupMenuModel.fromJson(Map<String, dynamic> json) {
    List<DynamicPopupMenuItem> formSections;
    formSections = (json['popupMenuItems'] as List).map((sectionJson) {
      return DynamicPopupMenuItem.fromJson(sectionJson);
    }).toList();
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
    return DynamicPopupMenuModel(
      id: json["id"],
      label: json["label"],
      name: json["name"],
      height: double.parse((json["height"]).toString()),
      width: double.parse((json["width"]).toString()),
      radius: json["radius"],
      showBorder: json["showBorder"],
      borderWidth: json["borderWidth"],
      borderColor: hexToColor(json["borderColor"]),
      backGroundColor: hexToColor(json["backGroundColor"]),
      textColorLabel: json["textColorLabel"],
      fontWeightLabel: json["fontWeightLabel"],
      fontSizeLabel: json["fontSizeLabel"],
      textColorSublabel: json["textColorSublabel"],
      fontWeightSublabel: json["fontWeightSublabel"],
      fontSizeSublabel: json["fontSizeSublabel"],
      fit: stringToBoxFit(json["fit"]),
      isHideAndShow: json["isHideAndShow"],
      item: json.containsKey('item')
          ? json['item']
          : null, // Handle missing 'items' field
      popupMenuItems: formSections,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}

class DynamicPopupMenuItem {
  final String? label;
  final String? imgUrl;
  final String? subtitle;
  final OnClickData? onClickData;

  DynamicPopupMenuItem({
    required this.label,
    required this.imgUrl,
    required this.subtitle,
    required this.onClickData,
  });

  factory DynamicPopupMenuItem.fromJson(Map<String, dynamic> json) {
    OnClickData? onClickData;
    if (json['onClickData'] != null) {
      var margin = json["onClickData"];
      onClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    return DynamicPopupMenuItem(
      label: json['label'],
      imgUrl: json['imgUrl'],
      subtitle: json['subtitle'],
      onClickData: onClickData,
    );
  }
}
