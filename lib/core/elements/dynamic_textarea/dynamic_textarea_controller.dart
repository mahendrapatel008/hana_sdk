import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_textarea/dynamic_textarea.dart';
import 'package:hana_sdk/core/elements/dynamic_textarea/dynamic_textarea_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicTextAreaController extends StatefulWidget {
  final DynamicTextAreaModel controller;
  final FormController formController;

  const DynamicTextAreaController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTextAreaController> createState() =>
      _DynamicTextAreaControllerState();
}

class _DynamicTextAreaControllerState extends State<DynamicTextAreaController> {
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

    DynamicTextAreaModel? containsAllPrerequisitesDesign;
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
                    DynamicTextAreaModel.fromJson(style);
              } else if (style is DynamicTextAreaModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicTextAreaModel.fromJson(style);
              } else if (style is DynamicTextAreaModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicTextAreaModel(
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      initialText: containsAllPrerequisitesDesign?.initialText ??
          widget.controller.initialText,
      backGroundColor: containsAllPrerequisitesDesign?.backGroundColor ??
          widget.controller.backGroundColor,
      textColor: containsAllPrerequisitesDesign?.textColor ??
          widget.controller.textColor,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      focusBorderColor: containsAllPrerequisitesDesign?.focusBorderColor ??
          widget.controller.focusBorderColor,
      placeholderColor: containsAllPrerequisitesDesign?.placeholderColor ??
          widget.controller.placeholderColor,
      fontSize: containsAllPrerequisitesDesign?.fontSize ??
          widget.controller.fontSize,
      fontWeight: containsAllPrerequisitesDesign?.fontWeight ??
          widget.controller.fontWeight,
      shadowColor: containsAllPrerequisitesDesign?.shadowColor ??
          widget.controller.shadowColor,
      shadowBlurRadius: containsAllPrerequisitesDesign?.shadowBlurRadius ??
          widget.controller.shadowBlurRadius,
      shadowOffsetX: containsAllPrerequisitesDesign?.shadowOffsetX ??
          widget.controller.shadowOffsetX,
      shadowOffsetY: containsAllPrerequisitesDesign?.shadowOffsetY ??
          widget.controller.shadowOffsetY,
      borderWidth: containsAllPrerequisitesDesign?.borderWidth ??
          widget.controller.borderWidth,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      maxLength: containsAllPrerequisitesDesign?.maxLength ??
          widget.controller.maxLength,
      maxLines: containsAllPrerequisitesDesign?.maxLines ??
          widget.controller.maxLines,
      placeholder: containsAllPrerequisitesDesign?.placeholder ??
          widget.controller.placeholder,
      paddingVertical: containsAllPrerequisitesDesign?.paddingVertical ??
          widget.controller.paddingVertical,
      paddingHorizontal: containsAllPrerequisitesDesign?.paddingHorizontal ??
          widget.controller.paddingHorizontal,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    return !containsAllPrerequisites
        ? DynamicTextArea(
            controller: displayController,
            formController: widget.formController,
          )
        : SizedBox.shrink();
  }
}
