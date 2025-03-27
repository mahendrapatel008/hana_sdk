import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicSafeareaModel {
  final double? elevation;
  final String? name;
  final MarginData? minimum;
  final bool? top;
  final bool? right;
  final bool? left;
  final bool? bottom;
  final bool? maintainBottomViewPadding;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;
  final dynamic items;

  DynamicSafeareaModel({
    this.elevation,
    this.name,
    this.minimum,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.maintainBottomViewPadding,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
    this.items,
  });

  factory DynamicSafeareaModel.fromJson(Map<String, dynamic> json) {
    MarginData? paddingData;
    if (json['minimum'] != null) {
      var margin = json["minimum"];
      paddingData = margin == null ? MarginData() : MarginData.fromJson(margin);
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
    return DynamicSafeareaModel(
      elevation: json['elevation']?.toDouble(),
      isHideAndShow: json["isHideAndShow"],
      name: json["name"],
      bottom: json["bottom"],
      left: json["left"],
      right: json["right"],
      top: json["top"],
      maintainBottomViewPadding: json["maintainBottomViewPadding"],
      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      minimum: paddingData,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elevation'] = elevation;
    data['name'] = name;
    data['minimum'] = minimum;
    data['items'] =
        items; // You may need to ensure this is properly serialized depending on its structure
    return data;
  }
}
