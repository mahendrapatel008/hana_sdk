import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_wrap/dynamic_wrap.dart';
import 'package:hana_sdk/core/elements/dynamic_wrap/dynamic_wrap_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicWrapController extends StatefulWidget {
  final DynamicWrapModel controller;
  final FormController formController;

  const DynamicWrapController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicWrapController> createState() => _DynamicWrapControllerState();
}

class _DynamicWrapControllerState extends State<DynamicWrapController> {
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
    DynamicWrapModel? containsAllPrerequisitesDesign;
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
                    DynamicWrapModel.fromJson(style);
              } else if (style is DynamicWrapModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicWrapModel.fromJson(style);
              } else if (style is DynamicWrapModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicWrapModel(
      alignment: containsAllPrerequisitesDesign?.alignment ??
          widget.controller.alignment,
      spacing:
          containsAllPrerequisitesDesign?.spacing ?? widget.controller.spacing,
      runSpacing: containsAllPrerequisitesDesign?.runSpacing ??
          widget.controller.runSpacing,
      direction: containsAllPrerequisitesDesign?.direction ??
          widget.controller.direction,
      clipBehavior: containsAllPrerequisitesDesign?.clipBehavior ??
          widget.controller.clipBehavior,
      crossAxisAlignment: containsAllPrerequisitesDesign?.crossAxisAlignment ??
          widget.controller.crossAxisAlignment,
      runAlignment: containsAllPrerequisitesDesign?.runAlignment ??
          widget.controller.runAlignment,
      textDirection: containsAllPrerequisitesDesign?.textDirection ??
          widget.controller.textDirection,
      verticalDirection: containsAllPrerequisitesDesign?.verticalDirection ??
          widget.controller.verticalDirection,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    List<Widget> formWidgets = [];

    for (var field in displayController.items) {
      if (field != null && field != []) {
        var formElement = ApiFormElements.fromJson({
          "type": field['type'],
          "items": field,
        });
        formElement.formController = widget.formController;
        var apiElementController =
            ApiElementController(formSectionsElements: formElement);
        formWidgets.add(apiElementController.buildFormElement());
      }
    }

    return !containsAllPrerequisites
        ? DynamicWrap(
            formWidgets: formWidgets,
            model: displayController,
          )
        : SizedBox.shrink();
  }
}
