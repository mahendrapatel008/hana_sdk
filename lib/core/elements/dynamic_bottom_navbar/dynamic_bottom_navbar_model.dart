
import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/radius_data.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicBottomNavModel {
  final BottomNavigationBarType? bottomNavigationBarType;
  final Color? unselectedLabelColor;
  final double? iconOuterHeight;
  final double? iconOuterWidth;
  final double? iconSize;
  final MarginData? padding;
  final MarginData? margin;
  final RadiusData? radius;
  final Color? backGroundColor;
  final Color? borderColor;
  final bool? showBorder;
  final int? borderWidth;
  final String? imgUrl;
  final BoxFit? fit;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? unselectedFontSize;
  final double? selectedFontSize;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;
  final List<DynamicNavItem>? items;

  DynamicBottomNavModel({
    this.items,
    this.bottomNavigationBarType,
    this.unselectedLabelColor,
    this.iconOuterHeight,
    this.iconOuterWidth,
    this.iconSize,
    this.radius,
    this.margin,
    this.backGroundColor,
    this.borderColor,
    this.borderWidth,
    this.fit,
    this.imgUrl,
    this.showBorder,
    this.padding,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.unselectedFontSize,
    this.selectedFontSize,
    this.landscapeLayout,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((item) => item.toJson()).toList(),
      'bottomNavigationBarType': bottomNavigationBarType?.toString(),
      'unselectedLabelColor': unselectedLabelColor?.value.toRadixString(16),
      'iconOuterHeight': iconOuterHeight,
      'iconOuterWidth': iconOuterWidth,
      'iconSize': iconSize,
      'padding': padding?.toJson(),
      'margin': margin?.toJson(),
      'radius': radius?.toJson(),
      'backGroundColor': backGroundColor?.value.toRadixString(16),
      'borderColor': borderColor?.value.toRadixString(16),
      'showBorder': showBorder,
      'borderWidth': borderWidth,
      'imgUrl': imgUrl,
      'fit': fit?.toString(),
      'backgroundColor': backgroundColor?.value.toRadixString(16),
      'selectedItemColor': selectedItemColor?.value.toRadixString(16),
      'unselectedItemColor': unselectedItemColor?.value.toRadixString(16),
      'unselectedFontSize': unselectedFontSize,
      'selectedFontSize': selectedFontSize,
      'landscapeLayout': landscapeLayout?.toString(),
    };
  }

  factory DynamicBottomNavModel.fromJson(Map<String, dynamic> json) {
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
        .map((item) => DynamicNavItem.fromJson(item))
        .toList();

    return DynamicBottomNavModel(
      items: items,
      radius: radiusData,
      margin: marginData,
      padding: paddingData,
      backGroundColor: hexToColor(json["backGroundColor"]),
      borderColor: hexToColor(json["borderColor"]),
      showBorder: json["showBorder"],
      imgUrl: getDynamicValue(json["name"]) ?? json["imgUrl"],
      fit: stringToBoxFit(json["fit"]),
      borderWidth: json["borderWidth"],
      bottomNavigationBarType:
          getBottomNavigationBarType(json['bottomNavigationBarType']),
      unselectedLabelColor: hexToColor(json['unselectedLabelColor']),
      iconOuterHeight: json['iconOuterHeight'] != null
          ? double.parse((json['iconOuterHeight']).toString())
          : null,
      iconOuterWidth: json['iconOuterWidth'] != null
          ? double.parse((json['iconOuterWidth']).toString())
          : null,
      iconSize: json['iconSize'] != null
          ? double.parse((json['iconSize']).toString())
          : null,
      backgroundColor: hexToColor(json['backgroundColor']),
      selectedItemColor: hexToColor(json['selectedItemColor']),
      unselectedItemColor: hexToColor(json['unselectedItemColor']),
      unselectedFontSize: json['unselectedFontSize'] != null
          ? double.parse((json['unselectedFontSize']).toString())
          : null,
      selectedFontSize: json['selectedFontSize'] != null
          ? double.parse((json['selectedFontSize']).toString())
          : null,
      landscapeLayout: stringToBottomNavigationBarLayout(
          (json['landscapeLayout']).toString()),
    );
  }
}

class DynamicNavItem {
  final String? icon;
  final String? label;
  final NavOnClickData? onClickData;

  DynamicNavItem({this.icon, this.label, this.onClickData});

  // toJson method for DynamicNavItem
  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'label': label,
      'onClickData': onClickData?.toJson(),
    };
  }

  factory DynamicNavItem.fromJson(Map<String, dynamic> json) {
    return DynamicNavItem(
      icon: json['icon'],
      label: json['label'],
      onClickData: json.containsKey('onClickData')
          ? NavOnClickData.fromJson(json['onClickData'])
          : null,
    );
  }
}

class NavOnClickData {
  final String pageName;
  final bool isBack;

  NavOnClickData({required this.pageName, required this.isBack});

  // toJson method for NavOnClickData
  Map<String, dynamic> toJson() {
    return {
      'pageName': pageName,
      'isBack': isBack,
    };
  }

  factory NavOnClickData.fromJson(Map<String, dynamic> json) {
    return NavOnClickData(
      pageName: json['pageName'] ?? '',
      isBack: json['isBack'] ?? false,
    );
  }
}
