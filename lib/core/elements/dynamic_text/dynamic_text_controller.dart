import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicTextController extends StatefulWidget {
  final DynamicTextModel controller;
  final FormController formController;

  const DynamicTextController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTextController> createState() => _DynamicTextControllerState();
}

class _DynamicTextControllerState extends State<DynamicTextController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DynamicTextModel? containsAllPrerequisitesDesign;
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

    // Check for prerequisites
    if (widget.controller.isHideAndShow ?? false) {
      containsAllPrerequisites = widget.controller.prerequisite != null &&
          widget.controller.prerequisite!.every((prerequisite) => widget
              .formController.savePrerequisitesNameData
              .contains(prerequisite.name));
    }

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
                    DynamicTextModel.fromJson(style);
              } else if (style is DynamicTextModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicTextModel.fromJson(style);
              } else if (style is DynamicTextModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }

    // Use containsAllPrerequisitesDesign if available, else fall back to widget.controller
    final displayController = DynamicTextModel(
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      // type: containsAllPrerequisitesDesign?.type ?? widget.controller.type,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      textAlign: containsAllPrerequisitesDesign?.textAlign ??
          widget.controller.textAlign,
      textColor: containsAllPrerequisitesDesign?.textColor ??
          widget.controller.textColor,
      fontWeight: containsAllPrerequisitesDesign?.fontWeight ??
          widget.controller.fontWeight,
      fontSize: containsAllPrerequisitesDesign?.fontSize ??
          widget.controller.fontSize,
      maxLines: containsAllPrerequisitesDesign?.maxLines ??
          widget.controller.maxLines,
      softWrap: containsAllPrerequisitesDesign?.softWrap ??
          widget.controller.softWrap,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      showTime: containsAllPrerequisitesDesign?.showTime ??
          widget.controller.showTime,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      overflow: containsAllPrerequisitesDesign?.overflow ??
          widget.controller.overflow,
      showLocation: containsAllPrerequisitesDesign?.showLocation ??
          widget.controller.showLocation,
      locationFormate: containsAllPrerequisitesDesign?.locationFormate ??
          widget.controller.locationFormate,
      addressFormate: containsAllPrerequisitesDesign?.addressFormate ??
          widget.controller.addressFormate,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
    );

    // Return the DynamicText widget with chosen properties
    return !containsAllPrerequisites
        ? DynamicText(
            controller: displayController,
            formController: widget.formController,
          )
        : const SizedBox.shrink();
  }
}
