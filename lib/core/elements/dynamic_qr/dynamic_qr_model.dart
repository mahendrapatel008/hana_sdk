
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicQRModel {
  final OnClickData? onClickData;
  final bool? isHideAndShow;
  final String? name;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicQRModel({
    this.onClickData,
    this.isHideAndShow,
    this.name,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicQRModel.fromJson(Map<String, dynamic> json) {
    // MarginData? marginData;
    // if (json['margin'] != null) {
    //   var margin = json["margin"];
    //   marginData = margin == null ? MarginData() : MarginData.fromJson(margin);
    // }
    // MarginData? paddingData;
    // if (json['padding'] != null) {
    //   var margin = json["padding"];
    //   paddingData = margin == null ? MarginData() : MarginData.fromJson(margin);
    // }
    // RadiusData? radiusData;
    // if (json['radius'] != null) {
    //   var radius = json["radius"];
    //   radiusData = radius == null ? RadiusData() : RadiusData.fromJson(radius);
    // }
    OnClickData? onClickData;
    if (json['onClickData'] != null) {
      var margin = json["onClickData"];
      onClickData =
          margin == null ? OnClickData() : OnClickData.fromJson(margin);
    }
    // GradientModel? gradientData;
    // if (json['gradient'] != null) {
    //   var margin = json["gradient"];
    //   gradientData =
    //       margin == null ? GradientModel() : GradientModel.fromJson(margin);
    // }

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
    return DynamicQRModel(
      onClickData: onClickData,
      name: json["name"],
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["onClickData"] = onClickData;
    return data;
  }
}
