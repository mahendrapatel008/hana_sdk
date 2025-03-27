
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/model/radius_data.dart';

class DynamicTableModel {
  final String? label;
  final String? dataKey;
  final String? type;
  final String? id;
  final String? name;
  final RadiusData? radius;
  final String? titleTextColor;
  final String? titleFontWeight;
  final int? titleFontSize;
  final String? titleBackGroundgColor;
  final String? valueTextColor;
  final String? valueFontWeight;
  final int? valueFontSize;
  final String? valueBackGroundgColor;
  final List<String>? listOfTitles;
  final List<List<String>>? listOfValues;
  final MarginData? titlePadding;
  final MarginData? valuePadding;
  final TableBorderModel? tableBorderModel;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicTableModel({
    required this.label,
    this.listOfTitles,
    this.listOfValues,
    this.tableBorderModel,
    this.type,
    this.id,
    this.name,
    this.dataKey,
    this.radius,
    this.titleTextColor,
    this.titleBackGroundgColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.valueTextColor,
    this.valueBackGroundgColor,
    this.valueFontSize,
    this.valueFontWeight,
    this.titlePadding,
    this.valuePadding,
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
      'radius': radius,
      'titleTextColor': titleTextColor,
      'titleFontWeight': titleFontWeight,
      'titleFontSize': titleFontSize,
      'titleBackGroundgColor': titleBackGroundgColor,
      'valueTextColor': valueTextColor,
      'valueFontWeight': valueFontWeight,
      'valueFontSize': valueFontSize,
      'valueBackGroundgColor': valueBackGroundgColor,
      'titlePadding': titlePadding,
      'valuePadding': valuePadding,
      'isHideAndShow': isHideAndShow,
      'tableBorderModel': tableBorderModel?.toJson(),
      'prerequisite': prerequisite?.map((e) => e.toJson()).toList(),
      'hanaPrerequisiteDesign':
          hanaPrerequisiteDesign?.map((e) => e.toJson()).toList(),
    };
  }

  factory DynamicTableModel.fromJson(Map<String, dynamic> json) {
    List<PrerequisiteModel>? prerequisiteList;
    if (json['prerequisite'] != null) {
      var prerequisites = json['prerequisite'] as List;
      prerequisiteList = prerequisites
          .map((item) => PrerequisiteModel.fromJson(item))
          .toList();
    }
    RadiusData? radiusData;
    if (json['radius'] != null) {
      var radius = json["radius"];
      radiusData = radius == null ? RadiusData() : RadiusData.fromJson(radius);
    }
    MarginData? titlePaddingData;
    if (json['titlePadding'] != null) {
      var margin = json["titlePadding"];
      titlePaddingData =
          margin == null ? MarginData() : MarginData.fromJson(margin);
    }
    MarginData? valuePaddingData;
    if (json['valuePadding'] != null) {
      var margin = json["valuePadding"];
      valuePaddingData =
          margin == null ? MarginData() : MarginData.fromJson(margin);
    }
    List<String>? titlesList;
    if (json['listOfTitles'] != null) {
      titlesList = List<String>.from(json['listOfTitles']);
    }
    List<List<String>>? valuesList;
    if (json['listOfValues'] != null) {
      // Parse listOfValues from JSON
      valuesList = (json['listOfValues'] as List)
          .map((row) => List<String>.from(row))
          .toList();
    }
    List<HanaPrerequisiteModel>? hanaPrerequisiteDesignList;
    if (json['hanaPrerequisiteDesign'] != null) {
      var hanaPrerequisiteDesigns = json['hanaPrerequisiteDesign'] as List;
      hanaPrerequisiteDesignList = hanaPrerequisiteDesigns
          .map((item) => HanaPrerequisiteModel.fromJson(item))
          .toList();
    }
    return DynamicTableModel(
      label: json["label"],
      type: json["type"],
      id: json["id"],
      name: json["name"],
      dataKey: json["dataKey"],
      isHideAndShow: json["isHideAndShow"],
      titleTextColor: json["titleTextColor"],
      titleFontWeight: json["titleFontWeight"],
      titleFontSize: json["titleFontSize"],
      titleBackGroundgColor: json["titleBackGroundgColor"],
      valueTextColor: json["valueTextColor"],
      valueFontWeight: json["valueFontWeight"],
      valueFontSize: json["valueFontSize"],
      valueBackGroundgColor: json["valueBackGroundgColor"],
      tableBorderModel: json['tableBorderModel'] != null
          ? TableBorderModel.fromJson(json['tableBorderModel'])
          : null,
      radius: radiusData,
      titlePadding: titlePaddingData,
      valuePadding: valuePaddingData,
      listOfTitles: titlesList,
      listOfValues: valuesList,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}

class TableBorderModel {
  final String? outsideBorderColor;
  final int? outsideBorderWidth;
  final String? insideBorderColor;
  final int? insideBorderWidth;

  TableBorderModel({
    this.outsideBorderColor,
    this.outsideBorderWidth,
    this.insideBorderColor,
    this.insideBorderWidth,
  });

  factory TableBorderModel.fromJson(Map<String, dynamic> json) {
    return TableBorderModel(
      outsideBorderColor: json['outsideBorderColor'],
      outsideBorderWidth: json['outsideBorderWidth'],
      insideBorderColor: json['insideBorderColor'],
      insideBorderWidth: json['insideBorderWidth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'outsideBorderColor': outsideBorderColor,
      'outsideBorderWidth': outsideBorderWidth,
      'insideBorderColor': insideBorderColor,
      'insideBorderWidth': insideBorderWidth,
    };
  }
}
