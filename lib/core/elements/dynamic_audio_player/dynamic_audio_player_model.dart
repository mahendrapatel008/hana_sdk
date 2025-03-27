import 'dart:ui';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicAudioPlayerModel {
  final String? audioUrl;
  final String? dataKey;
  final String? name;
  final bool required;
  final bool canScrub;
  final Color? inactiveTrackColor;
  final Color? activeTrackColor;
  final Color? thumbColor;
  final double? trackHeight;
  final double? enabledThumbRadius;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicAudioPlayerModel({
    this.audioUrl,
    this.name,
    this.required = false,
    this.canScrub = true,
    this.inactiveTrackColor,
    this.activeTrackColor,
    this.thumbColor,
    this.dataKey,
    this.trackHeight,
    this.enabledThumbRadius,
    this.prerequisite,
    this.isHideAndShow,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicAudioPlayerModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicAudioPlayerModel(
      audioUrl: json['audioUrl'],
      name: json['name'],
      required: json['required'],
      canScrub: json['canScrub'],
      dataKey: json['dataKey'],
      inactiveTrackColor: hexToColor(json['inactiveTrackColor']),
      activeTrackColor: hexToColor(json['activeTrackColor']),
      thumbColor: hexToColor(json['thumbColor']),
      trackHeight: double.parse((json['trackHeight']).toString()),
      enabledThumbRadius: double.parse((json['enabledThumbRadius']).toString()),
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
      isHideAndShow: json["isHideAndShow"],
    );
  }
}
