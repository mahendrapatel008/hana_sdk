import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicImageModel {
  final int? width;
  final int? height;
  final int? radius;
  final MarginData? margin;
  final MarginData? padding;
  final Color? backGroundColor;
  final Color? borderColor;
  final bool? showBorder;
  final int? borderWidth;
  final String? imgUrl;
  final String? dataKey;
  final bool? imgFromGallery;
  final BoxFit? fit;
  final String? placeholder;
  final String? id;
  final String? name;
  final OnClickData? onClickData;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicImageModel({
    this.placeholder,
    this.id,
    this.name,
    this.imgUrl,
    this.dataKey,
    this.imgFromGallery,
    this.borderWidth,
    this.height,
    this.width,
    this.fit,
    this.padding,
    this.backGroundColor,
    this.borderColor,
    this.showBorder,
    this.margin,
    this.radius,
    this.onClickData,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  Map<String, dynamic> toJson() {
    return {
      'imgUrl': imgUrl,
      'width': width,
      'height': height,
      'radius': radius,
      'margin': margin?.toJson(),
      'padding': padding?.toJson(),
      'backGroundColor': backGroundColor?.value.toRadixString(16),
      'borderColor':
          borderColor?.value.toRadixString(16),
      'showBorder': showBorder,
      'imgFromGallery': imgFromGallery,
      'borderWidth': borderWidth,
      'fit': fit.toString().split('.').last, // Convert enum to string
      'placeholder': placeholder,
      'id': id,
      'name': name,
      'dataKey': dataKey,
      'onClickData': onClickData?.toJson(),
      'isHideAndShow': isHideAndShow,
      'prerequisite': prerequisite?.map((e) => e.toJson()).toList(),
      'hanaPrerequisiteDesign':
          hanaPrerequisiteDesign?.map((e) => e.toJson()).toList(),
    };
  }

  factory DynamicImageModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicImageModel(
      padding: paddingData,
      margin: marginData,
      onClickData: onClickData,
      placeholder: json["placeholder"],
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderColor: hexToColor(json["borderColor"]),
      showBorder: json["showBorder"],
      imgFromGallery: json["imgFromGallery"],
      imgUrl: json["imgUrl"],
      fit: stringToBoxFit(json["fit"]),
      borderWidth: json["borderWidth"],
      name: json["name"],
      dataKey: json["dataKey"],
      id: json["id"],
      radius: json["radius"],
      height: json["height"],
      width: json["width"],
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
