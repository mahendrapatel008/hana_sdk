
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class DynamicRatingSystemModel {
  final String? label;
  final String? type;
  final String? id;
  final String? name;
  final double? minRating;
  final double? initialRating;
  final int? itemCount;
  final double? itemSize;
  final bool? required;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicRatingSystemModel({
    required this.label,
    this.type,
    this.id,
    this.name,
    this.minRating,
    this.initialRating,
    this.itemCount,
    this.itemSize,
    this.required,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'type': type,
      'id': id,
      'name': name,
      'initialRating': initialRating,
      'itemCount': itemCount,
      'minRating': minRating,
      'itemSize': itemSize,
      'required': required,
      'isHideAndShow': isHideAndShow,
      'prerequisite': prerequisite?.map((e) => e.toJson()).toList(),
      'hanaPrerequisiteDesign':
          hanaPrerequisiteDesign?.map((e) => e.toJson()).toList(),
    };
  }

  factory DynamicRatingSystemModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicRatingSystemModel(
      label: json["label"],
      type: json["type"],
      id: json["id"],
      name: json["name"],
      initialRating: json['initialRating'] != null
          ? double.parse((json['initialRating']).toString())
          : null,
      itemCount: json["itemCount"],
      minRating: json['minRating'] != null
          ? double.parse((json['minRating']).toString())
          : null,
      itemSize: json['itemSize'] != null
          ? double.parse((json['itemSize']).toString())
          : null,
      required: json["required"],
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  get validator => null;
}
