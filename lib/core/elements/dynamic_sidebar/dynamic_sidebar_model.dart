import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/model/radius_data.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicSidebarModel {
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final MarginData? padding;
  final MarginData? margin;
  final RadiusData? radius;
  final Color? backGroundColor;
  final Color? borderColor;
  final bool? showBorder;
  final int? borderWidth;
  final String? imgUrl;
  final BoxFit? fit;
  final String? showSideBarAt;
  final double? iconSize;
  final bool? isHideAndShow;
  final List<DynamicSidebarItem>? items;
  final List<PrerequisiteModel>? prerequisite;

  DynamicSidebarModel({
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showSideBarAt,
    this.radius,
    this.margin,
    this.backGroundColor,
    this.borderColor,
    this.borderWidth,
    this.fit,
    this.imgUrl,
    this.showBorder,
    this.padding,
    this.iconSize,
    this.items,
    this.isHideAndShow,
    this.prerequisite,
  });

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor?.value,
      'selectedItemColor': selectedItemColor?.value,
      'unselectedItemColor': unselectedItemColor?.value,
      'padding': padding?.toJson(),
      'margin': margin?.toJson(),
      'radius': radius?.toJson(),
      'backGroundColor': backGroundColor?.value,
      'borderColor': borderColor?.value,
      'showBorder': showBorder,
      'borderWidth': borderWidth,
      'imgUrl': imgUrl,
      'fit': fit?.toString(),
      'showSideBarAt': showSideBarAt,
      'iconSize': iconSize,
      'isHideAndShow': isHideAndShow,
      'items': items?.map((item) => item.toJson()).toList(),
      'prerequisite': prerequisite?.map((item) => item.toJson()).toList(),
    };
  }

  factory DynamicSidebarModel.fromJson(Map<String, dynamic> json) {
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

    var items = (json['items'] as List)
        .map((item) => DynamicSidebarItem.fromJson(item))
        .toList();

    List<PrerequisiteModel>? prerequisiteList;
    if (json['prerequisite'] != null) {
      var prerequisites = json['prerequisite'] as List;
      prerequisiteList = prerequisites
          .map((item) => PrerequisiteModel.fromJson(item))
          .toList();
    }
    return DynamicSidebarModel(
      radius: radiusData,
      margin: marginData,
      padding: paddingData,
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderColor: hexToColor(json["borderColor"]),
      showBorder: json["showBorder"],
      imgUrl: getDynamicValue(json["name"]) ?? json["imgUrl"] ?? "",
      fit: stringToBoxFit(json["fit"]),
      borderWidth: json["borderWidth"],
      backgroundColor: hexToColor(json['backgroundColor']),
      selectedItemColor: hexToColor(json['selectedItemColor']),
      unselectedItemColor: hexToColor(json['unselectedItemColor']),
      // iconSize: double.parse((json['iconSize']).toString()),
      showSideBarAt: json['showSideBarAt'],
      isHideAndShow: json["isHideAndShow"],
      items: items,
      prerequisite: prerequisiteList,
    );
  }
}

class DynamicSidebarItem {
  final String? icon;
  final String? label;
  final OnClickData? onClickData;

  DynamicSidebarItem({this.icon, this.label, this.onClickData});

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'label': label,
      'onClickData': onClickData?.toJson(),
    };
  }

  factory DynamicSidebarItem.fromJson(Map<String, dynamic> json) {
    return DynamicSidebarItem(
      icon: json['icon'],
      label: json['label'],
      onClickData: json.containsKey('onClickData')
          ? OnClickData.fromJson(json['onClickData'])
          : null,
    );
  }
}
