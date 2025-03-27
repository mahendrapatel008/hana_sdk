
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicGridViewModel {
  final String type;
  final List<dynamic> items;
  final dynamic item;
  final String? label;
  final String? dataKey;
  final String? id;
  final String? name;
  final int? crossAxisCount;
  final int? mainAxisSpacing;
  final int? crossAxisSpacing;
  final int? childHeight;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicGridViewModel({
    required this.type,
    required this.items,
    required this.item,
    required this.label,
    required this.id,
    required this.name,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childHeight,
    this.dataKey,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicGridViewModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicGridViewModel(
      type: json["type"],
      label: json["label"],
      name: json["name"],
      id: json["id"],
      dataKey: json["dataKey"],

      items: json.containsKey('items')
          ? json['items']
          : null, // Handle missing 'items' field
      item: json.containsKey('item')
          ? json['item']
          : null, // Handle missing 'items' field
      crossAxisCount: json["columnCount"],
      mainAxisSpacing: json["rowSpace"],
      crossAxisSpacing: json["columnSpace"],
      childHeight: json["childHeight"],
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
