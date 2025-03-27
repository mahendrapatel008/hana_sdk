
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicScrollViewModel {
  final String? name;
  final String? scrollDirection;
  final dynamic items;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicScrollViewModel({
    this.name,
    required this.scrollDirection,
    required this.items,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicScrollViewModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicScrollViewModel(
      name: json["name"],
      scrollDirection: json["scrollDirection"],
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
    data["scrollDirection"] = scrollDirection;
    return data;
  }
}
