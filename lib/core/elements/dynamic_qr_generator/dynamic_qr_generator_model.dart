import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/margin_data.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DynamicQrGeneratorModel {
  final String? id;
  final String? name;
  final String? dataKey;
  final bool? isHideAndShow;
  final double? size;
  final int? version;
  final Color? backgroundColor;
  final String? embeddedImage;
  final MarginData? padding;
  final String? semanticsLabel;
  final QrEyeStyle? eyeStyle;
  final QrEmbeddedImageStyle? embeddedImageStyle;
  final bool? gapless;
  final String? errorMessage;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicQrGeneratorModel({
    this.id,
    this.name,
    this.dataKey,
    this.isHideAndShow,
    this.size,
    this.version,
    this.backgroundColor,
    this.embeddedImage,
    this.padding,
    this.semanticsLabel,
    this.eyeStyle,
    this.embeddedImageStyle,
    this.gapless,
    this.errorMessage,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dataKey': dataKey,
      'isHideAndShow': isHideAndShow,
      'size': size,
      'version': version,
      'backgroundColor': backgroundColor?.value,
      'embeddedImage': embeddedImage,
      'padding': padding,
      'semanticsLabel': semanticsLabel,
      'eyeStyle': eyeStyle != null
          ? {
              'color': eyeStyle!.color?.value,
              'eyeShape': eyeStyle!.eyeShape?.index,
            }
          : null,
      'embeddedImageStyle': embeddedImageStyle != null
          ? {
              'size': embeddedImageStyle!.size != null
                  ? {
                      'width': embeddedImageStyle!.size!.width,
                      'height': embeddedImageStyle!.size!.height,
                    }
                  : null,
            }
          : null,
      'gapless': gapless,
      'errorMessage': errorMessage,
      'prerequisite': prerequisite?.map((e) => e.toJson()).toList(),
      'hanaPrerequisiteDesign':
          hanaPrerequisiteDesign?.map((e) => e.toJson()).toList(),
    };
  }

  factory DynamicQrGeneratorModel.fromJson(Map<String, dynamic> json) {
    MarginData? paddingData;
    if (json['padding'] != null) {
      var margin = json["padding"];
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
    return DynamicQrGeneratorModel(
      id: json["id"],
      name: json["name"],
      dataKey: json["dataKey"],
      isHideAndShow: json["isHideAndShow"],
      size: json["size"] != null ? (json["size"] as num).toDouble() : null,
      version: json["version"] as int?,
      backgroundColor: hexToColor(json["backGroundColor"]),
      embeddedImage: json["embeddedImage"],
      padding: paddingData,
      semanticsLabel: json["semanticsLabel"] as String?,
      eyeStyle: json["eyeStyle"] != null
          ? parseQrEyeStyle(json["eyeStyle"] as Map<String, dynamic>)
          : null,
      embeddedImageStyle: json["embeddedImageStyle"] != null
          ? parseQrEmbeddedImageStyle(
              json["embeddedImageStyle"] as Map<String, dynamic>)
          : null,
      gapless: json["gapless"] as bool?,
      errorMessage: json["errorMessage"] as String?,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  static QrEyeStyle parseQrEyeStyle(Map<String, dynamic> json) {
    return QrEyeStyle(
      color: Color(json['color'] as int),
      eyeShape: QrEyeShape.values[json['eyeShape'] as int],
    );
  }

  static QrEmbeddedImageStyle parseQrEmbeddedImageStyle(
      Map<String, dynamic> json) {
    return QrEmbeddedImageStyle(
      size: json['size'] != null
          ? Size(
              (json['size']['width'] as num).toDouble(),
              (json['size']['height'] as num).toDouble(),
            )
          : null,
    );
  }
}
