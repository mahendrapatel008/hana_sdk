import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicTextFieldModel {
  final String? label;
  final String? id;
  final String? name;
  final String? dataKey;
  final String? regex;
  final String? regexError;
  final bool? required;
  final int? maxLength;
  final TextInputType? keyboard;
  final String? hintText;
  final String? validator;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? saveAs;
  final bool? isReadOnlySave;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final bool? enable;
  final bool? readOnly;
  final bool? isBorder;
  final bool? floatingText;
  final Color? borderColor;
  final Color? backGroundColor;
  final int? borderRadius;
  final bool? obscureText;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicTextFieldModel({
    this.label,
    this.id,
    this.name,
    this.dataKey,
    this.regex,
    this.regexError,
    this.maxLength,
    this.required,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.textAlign,
    this.enable,
    this.readOnly,
    this.isReadOnlySave,
    this.keyboard,
    this.saveAs,
    this.hintText,
    this.validator,
    this.isBorder,
    this.floatingText,
    this.borderColor,
    this.backGroundColor,
    this.borderRadius,
    this.obscureText,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
    this.isHideAndShow,
  });

  factory DynamicTextFieldModel.fromJson(Map<String, dynamic> json) {
    String name = json["name"] ?? "";
    String label = json["label"] ?? "";
    String labela = name == 'AppName'
        ? SharedPrefs().appName.isNotEmpty
            ? SharedPrefs().appName
            : label
        : name == 'AppRole'
            ? SharedPrefs().appRole.isNotEmpty
                ? SharedPrefs().appRole
                : label
            : name == 'AppFirstPageName'
                ? SharedPrefs().appFirstPageName.isNotEmpty
                    ? SharedPrefs().appFirstPageName
                    : label
                : name == 'AppModuleName'
                    ? SharedPrefs().appModuleName.isNotEmpty
                        ? SharedPrefs().appModuleName
                        : label
                    : label;
    print("Current appName : ${SharedPrefs().appName}");
    print("Current appRole : ${SharedPrefs().appRole}");
    print("Current appFirstPageName : ${SharedPrefs().appFirstPageName}");
    print("Current appModuleName : ${SharedPrefs().appModuleName}");
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
    return DynamicTextFieldModel(
      label: labela,
      name: json["name"],
      dataKey: json["dataKey"],
      id: json["id"],
      regex: json["regex"],
      regexError: json["regexError"],
      required: json["required"],
      isBorder: json["isBorder"] ?? json["showBorder"],
      floatingText: json["floatingText"],
      obscureText: json["obscureText"],
      keyboard: getType(string: json["keyboard"]),
      textInputAction: stringToTextInputAction(json["textInputAction"]),
      hintText: json["hintText"],
      saveAs: json["saveAs"],
      validator: json["validator"],
      readOnly: json["readOnly"],
      isReadOnlySave: json["isReadOnlySave"],
      enable: json["enable"],
      maxLength: json["maxLength"],
      textAlign: stringToTextAlign(json["textAlign"]),
      prefixIcon: json["prefixIcon"],
      suffixIcon: json["suffixIcon"],
      borderRadius: json["borderRadius"],
      borderColor: hexToColor(json["borderColor"]),
      backGroundColor: hexToColor(json["backGroundColor"]),
      isHideAndShow: json["isHideAndShow"],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}
