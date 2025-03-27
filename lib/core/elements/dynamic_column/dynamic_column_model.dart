
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicColumnModel {
  final String? crossAxis;
  final String? mainAxis;
  final String? name;
  final bool? scrollable;
  final String? type;
  final bool? isHideAndShow;
  final List<dynamic>? items;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicColumnModel({
    required this.type,
    required this.scrollable,
    required this.crossAxis,
    this.name,
    required this.mainAxis,
    required this.items,
    this.prerequisite,
    this.isHideAndShow,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicColumnModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicColumnModel(
      type: json["type"],
      scrollable: json["scrollable"],
      name: json["name"],
      crossAxis: json["crossAxis"],
      isHideAndShow: json["isHideAndShow"],
      mainAxis: json["mainAxis"],
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
    data["type"] = type;
    data["name"] = name;
    data["scrollable"] = scrollable;
    data["crossAxis"] = crossAxis;
    data["mainAxis"] = mainAxis;
    return data;
  }
}
