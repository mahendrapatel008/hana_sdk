import 'dart:ui';

import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicOnboardingSlideModel {
  // final List<OnboardingSlide> slides;
  final Color? headerBackgroundColor;
  final Color? pageBackgroundColor;
  final String? finishButtonText;
  final String? name;
  final String? skipButtonText;
  final FontWeight? skipFontWeight;
  final FontWeight? loginFontWeight;
  final Color? controllerColor;
  final Color? skipTextColor;
  final Color? loginTextColor;
  final int? speed;
  final int? skipTextSize;
  final int? loginTextSize;
  final OnClickData? onClickData;
  final List<dynamic>? items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicOnboardingSlideModel({
    // required this.slides,
    this.headerBackgroundColor,
    this.pageBackgroundColor,
    this.finishButtonText,
    this.skipButtonText,
    this.controllerColor,
    this.skipTextColor,
    this.loginTextColor,
    this.speed,
    this.name,
    this.skipTextSize,
    this.skipFontWeight,
    this.loginTextSize,
    this.loginFontWeight,
    this.onClickData,
    this.items,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicOnboardingSlideModel.fromJson(Map<String, dynamic> json) {
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
    // List<OnboardingSlide> slides = (json['slides'] as List)
    //     .map((slideJson) => OnboardingSlide.fromJson(slideJson))
    //     .toList();
    return DynamicOnboardingSlideModel(
      // slides: slides,
      onClickData: onClickData,
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      headerBackgroundColor: hexToColor(json['headerBackgroundColor']),
      pageBackgroundColor: hexToColor(json['pageBackgroundColor']),
      finishButtonText: json['finishButtonText'],
      skipButtonText: json['skipButtonText'],
      skipTextColor: hexToColor(json['skipTextColor']),
      skipTextSize: json['skipTextSize'],
      skipFontWeight: stringToFontWeight(json['skipFontWeight']),
      loginTextColor: hexToColor(json['loginTextColor']),
      loginTextSize: json['loginTextSize'],
      loginFontWeight: stringToFontWeight(json['loginFontWeight']),
      controllerColor: hexToColor(json['controllerColor']),
      speed: json['speed'],
      name: json['name'],
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['headerBackgroundColor'] = headerBackgroundColor;
    data['pageBackgroundColor'] = pageBackgroundColor;
    data['controllerColor'] = controllerColor;
    data['finishButtonText'] = finishButtonText;
    data['skipButtonText'] = skipButtonText;
    data['skipTextColor'] = skipTextColor;
    data['loginTextColor'] = loginTextColor;
    data['speed'] = speed;
    data['skipTextSize'] = skipTextSize;
    data['skipFontWeight'] = skipFontWeight;
    data['loginTextSize'] = loginTextSize;
    data['loginFontWeight'] = loginFontWeight;
    data['items'] = items;
    return data;
  }
}

// class OnboardingSlide {
//   final String imageUrl;
//   final String title;
//   final String description;

//   OnboardingSlide({
//     required this.imageUrl,
//     required this.title,
//     required this.description,
//   });

//   factory OnboardingSlide.fromJson(Map<String, dynamic> json) {
//     return OnboardingSlide(
//       imageUrl: json['imageUrl'],
//       title: json['title'],
//       description: json['description'],
//     );
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['imageUrl'] = imageUrl;
//     data['title'] = title;
//     data['description'] = description;
//     return data;
//   }
// }
