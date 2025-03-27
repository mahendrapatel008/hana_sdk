import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicSliderModel {
  // final List<OnboardingSlide> slides;
  final OnClickData? onClickData;

  final List<dynamic> items;
  final int? initialPage;
  final bool? autoPlay;
  final Duration? autoPlayInterval;
  final bool? enableInfiniteScroll;
  final bool? interactable;
  final bool? enlargeCenterPage;
  final double? viewportFraction;
  final double? aspectRatio;
  final bool? reverse;
  final bool? pauseAutoPlayOnTouch;
  final bool? pauseAutoPlayInFiniteScroll;
  final Axis? scrollDirection;
  final bool? pageSnapping;
  final double? height;
  final Clip? clipBehavior;
  final bool? isHideAndShow;
  final String? name;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicSliderModel({
    // required this.slides,
    this.onClickData,
    required this.items,
    this.initialPage,
    this.autoPlay,
    this.autoPlayInterval,
    this.enableInfiniteScroll,
    this.interactable,
    this.enlargeCenterPage,
    this.viewportFraction,
    this.aspectRatio,
    this.reverse,
    this.pauseAutoPlayOnTouch,
    this.pauseAutoPlayInFiniteScroll,
    this.scrollDirection,
    this.pageSnapping,
    this.height,
    this.clipBehavior,
    this.name,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicSliderModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicSliderModel(
      // slides: slides,
      onClickData: onClickData,
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field

      initialPage: json['initialPage'],
      autoPlay: json['autoPlay'],
      autoPlayInterval: stringToDuration((json['autoPlayInterval']).toString()),
      enableInfiniteScroll: json['enableInfiniteScroll'],
      interactable: json['interactable'],
      enlargeCenterPage: json['enlargeCenterPage'],
      viewportFraction: double.parse(json['viewportFraction'].toString()),
      aspectRatio: double.parse((json['aspectRatio']).toString()),
      reverse: json['reverse'],
      pauseAutoPlayOnTouch: json['pauseAutoPlayOnTouch'],
      pauseAutoPlayInFiniteScroll: json['pauseAutoPlayInFiniteScroll'],
      scrollDirection: stringToAxis(json['scrollDirection']),
      pageSnapping: json['pageSnapping'],
      height: json['height']?.toDouble(),
      clipBehavior: stringToClip(json['clipBehavior']),
      name: json['name'],
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items;
    return data;
  }
}
