import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_checkbox/dynamic_checkbox.dart';
import 'package:hana_sdk/core/elements/dynamic_checkbox/dynamic_checkbox_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicCheckBoxController extends StatefulWidget {
  final DynamicCheckBoxModel controller;
  final FormController formController;

  const DynamicCheckBoxController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicCheckBoxController> createState() =>
      _DynamicCheckBoxControllerState();
}

class _DynamicCheckBoxControllerState extends State<DynamicCheckBoxController> {
  TextEditingController consttext = TextEditingController();
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
    DynamicCheckBoxModel? containsAllPrerequisitesDesign;
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
                    DynamicCheckBoxModel.fromJson(style);
              } else if (style is DynamicCheckBoxModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicCheckBoxModel.fromJson(style);
              } else if (style is DynamicCheckBoxModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }

    final displayController = DynamicCheckBoxModel(
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      backGroundColor: containsAllPrerequisitesDesign?.backGroundColor ??
          widget.controller.backGroundColor,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      borderWidth: containsAllPrerequisitesDesign?.borderWidth ??
          widget.controller.borderWidth,
      textColor: containsAllPrerequisitesDesign?.textColor ??
          widget.controller.textColor,
      textSize: containsAllPrerequisitesDesign?.textSize ??
          widget.controller.textSize,
      textWeight: containsAllPrerequisitesDesign?.textWeight ??
          widget.controller.textWeight,
      checkboxColor: containsAllPrerequisitesDesign?.checkboxColor ??
          widget.controller.checkboxColor,
      checkTickColor: containsAllPrerequisitesDesign?.checkTickColor ??
          widget.controller.checkTickColor,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    return !containsAllPrerequisites
        ? DynamicCheckBox(
            controller: displayController,
            formController: widget.formController,
          )
        : SizedBox.shrink();
  }
}
