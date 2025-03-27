import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicImageSelectorModel {
  final String? label;
  final String? type;
  final String? id;
  final String? name;
  final String? dataKey;
  final String? imgUrl;
  final int? width;
  final int? height;
  final BoxFit? fit;
  final String? placeholder;
  final String? textAlign;
  final String? textColor;
  final String? fontWeight;
  final TextOverflow? overflow;
  final int? fontSize;
  final int? maxLines;
  final bool? softWrap;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicImageSelectorModel({
    required this.label,
    this.type,
    this.id,
    this.name,
    this.dataKey,
    this.imgUrl,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
    this.textAlign,
    this.textColor,
    this.fontWeight,
    this.fontSize,
    this.overflow,
    this.maxLines,
    this.softWrap,
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
      'dataKey': dataKey,
      'imgUrl': imgUrl,
      'width': width,
      'height': height,
      'fit': fit.toString().split('.').last, // Convert enum to string
      'placeholder': placeholder,
      'textAlign': textAlign,
      'textColor': textColor,
      'fontWeight': fontWeight,
      'overflow': overflow.toString().split('.').last, // Convert enum to string
      'fontSize': fontSize,
      'maxLines': maxLines,
      'softWrap': softWrap,
      'isHideAndShow': isHideAndShow,
      'prerequisite': prerequisite?.map((e) => e.toJson()).toList(),
      'hanaPrerequisiteDesign':
          hanaPrerequisiteDesign?.map((e) => e.toJson()).toList(),
    };
  }

  factory DynamicImageSelectorModel.fromJson(Map<String, dynamic> json) {
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
    return DynamicImageSelectorModel(
      label: json["label"],
      type: json["type"],
      id: json["id"],
      name: json["name"],
      dataKey: json["dataKey"],
      imgUrl: getDynamicValue(json["name"]) ?? json["imgUrl"],
      height: json["height"],
      width: json["width"],
      fit: stringToBoxFit(json["fit"]),
      placeholder: json["placeholder"],
      isHideAndShow: json["isHideAndShow"],
      textAlign: json["textAlign"],
      overflow: stringToTextOverflow(json["overflow"]),
      textColor: json["textColor"],
      fontWeight: json["fontWeight"],
      fontSize: json["fontSize"],
      maxLines: json["maxLines"],
      softWrap: json["softWrap"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
