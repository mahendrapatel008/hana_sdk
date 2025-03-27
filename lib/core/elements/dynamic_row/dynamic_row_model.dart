
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicRowModel {
  final String? crossAxis;
  final String? mainAxis;
  final bool? scrollable;
  final String? name;
  final String? type;
  final List<dynamic>? items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicRowModel({
    this.type,
    this.name,
    this.scrollable,
    this.crossAxis,
    this.mainAxis,
    this.items,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicRowModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicRowModel(
      type: json["type"],
      name: json["name"],
      crossAxis: json["crossAxis"],
      mainAxis: json["mainAxis"],
      scrollable: json["scrollable"],
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
    data["items"] = items;
    data["name"] = name;
    data["type"] = type;
    data["scrollable"] = scrollable;
    data["crossAxis"] = crossAxis;
    data["mainAxis"] = mainAxis;
    return data;
  }
}
