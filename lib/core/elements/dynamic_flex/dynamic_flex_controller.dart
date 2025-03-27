import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_flex/dynamic_flex.dart';
import 'package:hana_sdk/core/elements/dynamic_flex/dynamic_flex_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicFlexController extends StatefulWidget {
  final DynamicFlexModel controller;
  final FormController formController;

  const DynamicFlexController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicFlexController> createState() => _DynamicFlexControllerState();
}

class _DynamicFlexControllerState extends State<DynamicFlexController> {
  @override
  Widget build(BuildContext context) {
    bool containsAllPrerequisites = false;
    if (widget.formController.dynamicData.containsKey("dependentInvisibleFields")) {
      try {
        final dependentInvisibleFields = DependentInvisibleFields.fromJson(
          widget.formController.dynamicData["dependentInvisibleFields"],
        );
        containsAllPrerequisites = dependentInvisibleFields.fieldNames.contains(widget.controller.name);
      } catch (e) {
        print("Error parsing dependentInvisibleFields: $e");
      }
    }

    if (widget.controller.isHideAndShow ?? false) {
      containsAllPrerequisites = widget.controller.prerequisite != null &&
          widget.controller.prerequisite!.every(
                (prerequisite) => widget.formController.savePrerequisitesNameData.contains(prerequisite.name),
          );
    }

    DynamicFlexModel? containsAllPrerequisitesDesign;
    if (!containsAllPrerequisites) {
      if (widget.controller.hanaPrerequisiteDesign != null && widget.controller.hanaPrerequisiteDesign!.isNotEmpty) {
        final matchingPrerequisites = widget.formController.savePrerequisitesNameData
            .where((name) => widget.controller.hanaPrerequisiteDesign!.any((prerequisite) => prerequisite.name == name))
            .map((name) => widget.controller.hanaPrerequisiteDesign!.firstWhere((prerequisite) => prerequisite.name == name))
            .toList();

        for (var prerequisite in matchingPrerequisites) {
          if (prerequisite.isOtherRemove == true) {
            widget.formController.savePrerequisitesNameData
                .where((name) =>
            name != prerequisite.name &&
                widget.controller.hanaPrerequisiteDesign!.any((otherPrerequisite) => otherPrerequisite.name == name))
                .toList()
                .forEach((name) => widget.formController.removePrerequisitesName(context, name as String?));

            final remainingPrerequisites = widget.controller.hanaPrerequisiteDesign!
                .where((prerequisite) => widget.formController.savePrerequisitesNameData.contains(prerequisite.name))
                .toList();

            if (remainingPrerequisites.isNotEmpty) {
              var style = remainingPrerequisites.last.style;
              containsAllPrerequisitesDesign = style is Map<String, dynamic>
                  ? DynamicFlexModel.fromJson(style)
                  : style;
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;
              containsAllPrerequisitesDesign = style is Map<String, dynamic>
                  ? DynamicFlexModel.fromJson(style)
                  : style;
            }
          }
        }
      }
    }

    final displayController = DynamicFlexModel(
      direction: containsAllPrerequisitesDesign?.direction ?? widget.controller.direction,
      mainAxisAlignment: containsAllPrerequisitesDesign?.mainAxisAlignment ?? widget.controller.mainAxisAlignment,
      crossAxisAlignment: containsAllPrerequisitesDesign?.crossAxisAlignment ?? widget.controller.crossAxisAlignment,
      mainAxisSize: containsAllPrerequisitesDesign?.mainAxisSize ?? widget.controller.mainAxisSize,
      verticalDirection: containsAllPrerequisitesDesign?.verticalDirection ?? widget.controller.verticalDirection,
      textDirection: containsAllPrerequisitesDesign?.textDirection ?? widget.controller.textDirection,
      clipBehavior: containsAllPrerequisitesDesign?.clipBehavior ?? widget.controller.clipBehavior,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ?? widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ?? widget.controller.prerequisite,
      hanaPrerequisiteDesign: containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ?? widget.controller.hanaPrerequisiteDesign,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
    );

    Widget? formWidgets;
    var field = displayController.items;
    if (field != null && field != []) {
      var formElement = ApiFormElements.fromJson({
        "type": field["type"],
        "items": field,
      });
      formElement.formController = widget.formController;
      var apiElementController =
      ApiElementController(formSectionsElements: formElement);
      formWidgets = apiElementController.buildFormElement();
    }

    return !containsAllPrerequisites
        ? DynamicFlex(
      model: displayController,
      children: formWidgets != null ? [formWidgets] : [],
    )
        : SizedBox.shrink();
  }
}
