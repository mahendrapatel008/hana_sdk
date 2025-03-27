import 'dart:ui';

import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicInkWellModel {
  final OnClickData? onTap;
  final OnClickData? onDoubleTap;
  final OnClickData? onLongPress;
  final OnClickData? onHover;
  final String? name;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Duration? hoverDuration;
  // final WrapCrossAlignment? crossAxisAlignment;
  // final WrapAlignment? runAlignment;
  // final TextDirection? textDirection;
  // final VerticalDirection? verticalDirection;
  final dynamic items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicInkWellModel({
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onHover,
    this.name,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.hoverDuration,
    // this.clipBehavior,
    // this.crossAxisAlignment,
    // this.runAlignment,
    // this.textDirection,
    // this.verticalDirection,
    this.items,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicInkWellModel.fromJson(Map<String, dynamic> json) {
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
    OnClickData? onTaponClickData;
    if (json['onTap'] != null) {
      var margin = json["onTap"];
      onTaponClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    OnClickData? onDoubleTaponClickData;
    if (json['onDoubleTap'] != null) {
      var margin = json["onDoubleTap"];
      onDoubleTaponClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    OnClickData? onLongPressonClickData;
    if (json['onLongPress'] != null) {
      var margin = json["onLongPress"];
      onLongPressonClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    OnClickData? onHoveronClickData;
    if (json['onHover'] != null) {
      var margin = json["onHover"];
      onHoveronClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    return DynamicInkWellModel(
      onTap: onTaponClickData,
      onDoubleTap: onDoubleTaponClickData,
      onLongPress: onLongPressonClickData,
      onHover: onHoveronClickData,
      hoverColor: hexToColor(json["hoverColor"]),
      focusColor: hexToColor(json["focusColor"]),
      highlightColor: hexToColor(json["highlightColor"]),
      splashColor: hexToColor(json["splashColor"]),
      hoverDuration: stringToDuration((json['hoverDuration']).toString()),
      // clipBehavior: stringToClip(json["clipBehavior"]),
      // crossAxisAlignment:
      //     stringToWrapCrossAlignment(json["crossAxisAlignment"]),
      // runAlignment: stringToWrapAlignment(json["runAlignment"]),
      // textDirection: stringToTextDirection(json["textDirection"]),
      // verticalDirection: stringToVerticalDirection(json["verticalDirection"]),
      name: json["name"],
      isHideAndShow: json["isHideAndShow"],
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["alignment"] = onTap;
    data["spacing"] = onDoubleTap;
    data["runSpacing"] = onLongPress;
    data["direction"] = onHover;
    data["hoverColor"] = hoverColor;
    data["hoverColor"] = hoverColor;
    data["highlightColor"] = highlightColor;
    data["splashColor"] = splashColor;
    // data["clipBehavior"] = clipBehavior?.index; // Store index of Clip
    // data["crossAxisAlignment"] =
    //     crossAxisAlignment?.index; // Store index of CrossAxisAlignment
    // data["runAlignment"] = runAlignment?.index; // Store index of WrapAlignment
    // data["textDirection"] =
    //     textDirection?.index; // Store index of TextDirection
    // data["verticalDirection"] =
    //     verticalDirection?.index; // Store index of VerticalDirection
    data["items"] = items; // Serialize items

    return data;
  }
}
