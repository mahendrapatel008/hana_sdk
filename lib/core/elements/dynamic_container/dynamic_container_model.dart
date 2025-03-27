import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/gradient_model.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/model/radius_data.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicContainerModel {
  final int? width;
  final int? height;
  final RadiusData? radius;
  final OnClickData? onClickData;
  final MarginData? margin;
  final dynamic items;
  final MarginData? padding;
  final Color? shadowColor;
  final double? elevation;
  final double? spreadRadius;
  final Color? backGroundColor;
  final Color? borderColor;
  final bool? showBorder;
  final int? borderWidth;
  final bool? isCenter;
  final String? url;
  final String? dataKey;
  final bool? isUrlLauncher;
  final GradientModel? gradient;
  final BoxFit? fit;
  final String? imgUrl;
  final double? imageOpacity;
  final ShadowOffset? shadowOffset;
  final bool? isHideAndShow;
  final String? name;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicContainerModel({
    this.padding,
    this.backGroundColor,
    this.borderColor,
    this.showBorder,
    this.items,
    this.width,
    this.shadowColor,
    this.elevation,
    this.spreadRadius,
    this.shadowOffset,
    this.height,
    this.margin,
    this.radius,
    this.borderWidth,
    this.isCenter,
    this.onClickData,
    this.url,
    this.dataKey,
    this.isUrlLauncher,
    this.gradient,
    this.fit,
    this.imgUrl,
    this.imageOpacity,
    this.name,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicContainerModel.fromJson(Map<String, dynamic> json) {
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
    if (json['radius'] != null) {
      var radius = json["radius"];
      radiusData = radius == null ? RadiusData() : RadiusData.fromJson(radius);
    }
    OnClickData? onClickData;
    if (json['onClickData'] != null) {
      var margin = json["onClickData"];
      onClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    GradientModel? gradientData;
    if (json['gradient'] != null) {
      var margin = json["gradient"];
      gradientData =
          margin == null ? GradientModel() : GradientModel.fromJson(margin);
    }
    ShadowOffset? shadowOffsetZ;
    if (json['shadowOffset'] != null) {
      var margin = json["shadowOffset"];
      shadowOffsetZ =
          margin == null ? ShadowOffset() : ShadowOffset.fromJson(margin);
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
    return DynamicContainerModel(
      width: json["width"],
      height: json["height"],
      radius: radiusData,
      borderWidth: json["borderWidth"],
      margin: marginData,
      padding: paddingData,
      onClickData: onClickData,
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      elevation: json["elevation"] != null
          ? double.parse(json["elevation"].toString())
          : null,
      spreadRadius: json["spreadRadius"] != null
          ? double.parse(json["spreadRadius"].toString())
          : null,
      shadowColor: hexToColor(json['shadowColor']),
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderColor: hexToColor(json["borderColor"]),
      showBorder: json["showBorder"],
      isCenter: json["isCenter"],
      isUrlLauncher: json["isUrlLauncher"],
      url: json["url"],
      dataKey: json["dataKey"],
      isHideAndShow: json["isHideAndShow"],
      fit: stringToBoxFit(json["fit"]),
      imgUrl: json["imgUrl"],
      name: json["name"],
      imageOpacity: json["imageOpacity"] != null
          ? double.parse(json["imageOpacity"].toString())
          : null,
      gradient: gradientData,
      shadowOffset: shadowOffsetZ,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["items"] = items;
    data["width"] = width;
    data["height"] = height;
    data["radius"] = radius;
    data["margin"] = margin;
    data["onClickData"] = onClickData;
    data["borderWidth"] = borderWidth;
    data["padding"] = padding;
    data["backGroundColor"] = backGroundColor;
    data["borderColor"] = borderColor;
    data['elevation'] = elevation;
    data['shadowColor'] = shadowColor;
    data["showBorder"] = showBorder;
    data["isCenter"] = isCenter;
    data["isUrlLauncher"] = isUrlLauncher;
    data["url"] = url;
    data["dataKey"] = dataKey;
    data["fit"] = fit;
    data["imgUrl"] = imgUrl;
    data["imageOpacity"] = imageOpacity;
    return data;
  }
}

class ShadowOffset {
  final double? xOffset;
  final double? yOffset;

  ShadowOffset({
    this.xOffset,
    this.yOffset,
  });

  factory ShadowOffset.fromJson(Map<String, dynamic> json) {
    return ShadowOffset(
      xOffset: json['xOffset'] != null
          ? double.tryParse(json['xOffset'].toString())
          : null,
      yOffset: json['yOffset'] != null
          ? double.tryParse(json['yOffset'].toString())
          : null,
    );
  }
}
