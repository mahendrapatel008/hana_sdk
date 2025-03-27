import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_row/dynamic_row.dart';
import 'package:hana_sdk/core/elements/dynamic_row/dynamic_row_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicRowController extends StatefulWidget {
  final DynamicRowModel controller;
  final FormController formController;

  const DynamicRowController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicRowController> createState() => _DynamicRowControllerState();
}

class _DynamicRowControllerState extends State<DynamicRowController> {
  Axis scrollDirection = Axis.horizontal;

  @override
  void initState() {
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
    DynamicRowModel? containsAllPrerequisitesDesign;
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
                    DynamicRowModel.fromJson(style);
              } else if (style is DynamicRowModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicRowModel.fromJson(style);
              } else if (style is DynamicRowModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicRowModel(
      type: containsAllPrerequisitesDesign?.type ?? widget.controller.type,
      scrollable: containsAllPrerequisitesDesign?.scrollable ??
          widget.controller.scrollable,
      crossAxis: containsAllPrerequisitesDesign?.crossAxis ??
          widget.controller.crossAxis,
      mainAxis: containsAllPrerequisitesDesign?.mainAxis ??
          widget.controller.mainAxis,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
    );

    List<Widget> formWidgets = [];
    for (var field in displayController.items ?? []) {
      var formElement = ApiFormElements.fromJson({
        "type": field['type'],
        "items": field,
      });
      formElement.formController = widget.formController;
      var apiElementController =
          ApiElementController(formSectionsElements: formElement);
      formWidgets.add(apiElementController.buildFormElement());
    }
    return !containsAllPrerequisites
        ? DynamicRow(model: displayController, formWidgets: formWidgets)
        : SizedBox.shrink();
  }
}
