import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_otp/dynamic_otp_model.dart';
import 'package:hana_sdk/core/elements/dynamic_otp/dynamic_otpview.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicOtpController extends StatefulWidget {
  final DynamicOtpViewModel controller;
  final FormController formController;

  const DynamicOtpController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicOtpController> createState() => _DynamicOtpControllerState();
}

class _DynamicOtpControllerState extends State<DynamicOtpController> {
  @override
  void initState() {
    widget.formController.saveFieldName(widget.controller.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool containsAllPrerequisites = false;
    if (widget.formController.dynamicData
        .containsKey("dependentInvisibleFields")) {
      try {
        // Directly pass the Map if it's already a parsed JSON object
        final dependentInvisibleFields = DependentInvisibleFields.fromJson(
          widget.formController.dynamicData["dependentInvisibleFields"],
        );
        // Check if any of the dependentInvisibleFields contains the name
        containsAllPrerequisites = dependentInvisibleFields.fieldNames
            .contains(widget.controller.name);
      } catch (e) {
        print("Error parsing dependentInvisibleFields: $e");
      }
    }
    if (widget.controller.isHideAndShow ?? false) {
      containsAllPrerequisites = widget.controller.prerequisite != null &&
          widget.controller.prerequisite!.every((prerequisite) => widget
              .formController.savePrerequisitesNameData
              .contains(prerequisite.name));
    }
    DynamicOtpViewModel? containsAllPrerequisitesDesign;
    // Handle hanaPrerequisiteDesign if no prerequisites matched
    if (!containsAllPrerequisites) {
      if (widget.controller.hanaPrerequisiteDesign != null &&
          widget.controller.hanaPrerequisiteDesign!.isNotEmpty) {
        final matchingPrerequisites = widget
            .formController.savePrerequisitesNameData
            .where((name) => widget.controller.hanaPrerequisiteDesign!
                .any((prerequisite) => prerequisite.name == name))
            .map((name) => widget.controller.hanaPrerequisiteDesign!
                .firstWhere((prerequisite) => prerequisite.name == name))
            .toList();

        // Check if any matching prerequisites should remove others
        for (var prerequisite in matchingPrerequisites) {
          if (prerequisite.isOtherRemove == true) {
            widget.formController.savePrerequisitesNameData
                .where((name) =>
                    name != prerequisite.name &&
                    widget.controller.hanaPrerequisiteDesign!.any(
                        (otherPrerequisite) => otherPrerequisite.name == name))
                .toList()
                .forEach((name) => widget.formController
                    .removePrerequisitesName(context, name as String?));

            final remainingPrerequisites = widget
                .controller.hanaPrerequisiteDesign!
                .where((prerequisite) => widget
                    .formController.savePrerequisitesNameData
                    .contains(prerequisite.name))
                .toList();

            if (remainingPrerequisites.isNotEmpty) {
              var style = remainingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicOtpViewModel.fromJson(style);
              } else if (style is DynamicOtpViewModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicOtpViewModel.fromJson(style);
              } else if (style is DynamicOtpViewModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicOtpViewModel(
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      numberOfFields: containsAllPrerequisitesDesign?.numberOfFields ??
          widget.controller.numberOfFields,
      borderWidth: containsAllPrerequisitesDesign?.borderWidth ??
          widget.controller.borderWidth,
      showFieldAsBox: containsAllPrerequisitesDesign?.showFieldAsBox ??
          widget.controller.showFieldAsBox,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      focusedBorderColor: containsAllPrerequisitesDesign?.focusedBorderColor ??
          widget.controller.focusedBorderColor,
      fillColor: containsAllPrerequisitesDesign?.fillColor ??
          widget.controller.fillColor,
      fieldWidth: containsAllPrerequisitesDesign?.fieldWidth ??
          widget.controller.fieldWidth,
      fieldHeight: containsAllPrerequisitesDesign?.fieldHeight ??
          widget.controller.fieldHeight,
      fontName: containsAllPrerequisitesDesign?.fontName ??
          widget.controller.fontName,
      fontSize: containsAllPrerequisitesDesign?.fontSize ??
          widget.controller.fontSize,
      fontWeight: containsAllPrerequisitesDesign?.fontWeight ??
          widget.controller.fontWeight,
      textColor: containsAllPrerequisitesDesign?.textColor ??
          widget.controller.textColor,
      cursorColor: containsAllPrerequisitesDesign?.cursorColor ??
          widget.controller.cursorColor,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    return !containsAllPrerequisites
        ? DynamicOtpview(
            model: displayController,
            formController: widget.formController,
          )
        : SizedBox.shrink();
  }
}
