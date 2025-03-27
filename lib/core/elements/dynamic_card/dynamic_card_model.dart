import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/model/radius_data.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicCardModel {
  final double? elevation;
  final String? name;
  final Color? shadowColor;
  final Color? cardColor;
  final RadiusData? borderRadius;
  final MarginData? margin;
  final MarginData? padding;
  final Clip? clipBehavior;
  final bool? borderOnForeground;
  final bool? semanticContainer;
  final Color? surfaceTintColor;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  final dynamic items;

  DynamicCardModel({
    this.elevation,
    this.name,
    this.shadowColor,
    this.cardColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.clipBehavior,
    this.borderOnForeground,
    this.semanticContainer,
    this.surfaceTintColor,
    this.prerequisite,
    this.isHideAndShow,
    this.items,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicCardModel.fromJson(Map<String, dynamic> json) {
    MarginData? marginData;
    if (json['margin'] != null) {
      var margin = json["margin"];
      marginData = margin == null ? MarginData() : MarginData.fromJson(margin);
    }
    MarginData? paddingData;
    if (json['padding'] != null) {
      var margin = json["padding"];
      paddingData = margin == null ? MarginData() : MarginData.fromJson(margin);
    }
    RadiusData? radiusData;
    if (json['borderRadius'] != null) {
      var radius = json["borderRadius"];
      radiusData = radius == null ? RadiusData() : RadiusData.fromJson(radius);
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
    return DynamicCardModel(
      elevation: json['elevation']?.toDouble(),
      isHideAndShow: json["isHideAndShow"],
      name: json["name"],
      shadowColor: hexToColor(json['shadowColor']),
      cardColor: hexToColor(json['cardColor']),
      borderRadius: radiusData,
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      margin: marginData,
      padding: paddingData,
      borderOnForeground: json['borderOnForeground'],
      semanticContainer: json['semanticContainer'],
      surfaceTintColor: hexToColor(json['surfaceTintColor']),
      clipBehavior: stringToClip(json['clipBehavior']),
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elevation'] = elevation;
    data['name'] = name;
    data['shadowColor'] = shadowColor;
    data['cardColor'] = cardColor;
    data['borderRadius'] = borderRadius;
    data['margin'] = margin;
    data['padding'] = padding;
    data['clipBehavior'] = clipBehavior;
    data['borderOnForeground'] = borderOnForeground;
    data['semanticContainer'] = semanticContainer;
    data['surfaceTintColor'] = surfaceTintColor;
    data['items'] =
        items; // You may need to ensure this is properly serialized depending on its structure
    return data;
  }
}
