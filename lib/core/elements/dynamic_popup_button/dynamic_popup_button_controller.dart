import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_popup_button/dynamic_popup_button.dart';
import 'package:hana_sdk/core/elements/dynamic_popup_button/dynamic_popup_button_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicPopupMenuController extends StatefulWidget {
  final DynamicPopupMenuModel controller;
  final FormController formController;

  const DynamicPopupMenuController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicPopupMenuController> createState() =>
      _DynamicPopupMenuControllerState();
}

class _DynamicPopupMenuControllerState
    extends State<DynamicPopupMenuController> {
  late Widget formWidgets;

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
    DynamicPopupMenuModel? containsAllPrerequisitesDesign;
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
                    DynamicPopupMenuModel.fromJson(style);
              } else if (style is DynamicPopupMenuModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicPopupMenuModel.fromJson(style);
              } else if (style is DynamicPopupMenuModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicPopupMenuModel(
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      height:
          containsAllPrerequisitesDesign?.height ?? widget.controller.height,
      width: containsAllPrerequisitesDesign?.width ?? widget.controller.width,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      backGroundColor: containsAllPrerequisitesDesign?.backGroundColor ??
          widget.controller.backGroundColor,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      borderWidth: containsAllPrerequisitesDesign?.borderWidth ??
          widget.controller.borderWidth,
      showBorder: containsAllPrerequisitesDesign?.showBorder ??
          widget.controller.showBorder,
      textColorLabel: containsAllPrerequisitesDesign?.textColorLabel ??
          widget.controller.textColorLabel,
      fontWeightLabel: containsAllPrerequisitesDesign?.fontWeightLabel ??
          widget.controller.fontWeightLabel,
      fontSizeLabel: containsAllPrerequisitesDesign?.fontSizeLabel ??
          widget.controller.fontSizeLabel,
      textColorSublabel: containsAllPrerequisitesDesign?.textColorSublabel ??
          widget.controller.textColorSublabel,
      fontWeightSublabel: containsAllPrerequisitesDesign?.fontWeightSublabel ??
          widget.controller.fontWeightSublabel,
      fontSizeSublabel: containsAllPrerequisitesDesign?.fontSizeSublabel ??
          widget.controller.fontSizeSublabel,
      fit: containsAllPrerequisitesDesign?.fit ?? widget.controller.fit,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      item: containsAllPrerequisitesDesign?.item ?? widget.controller.item,
      popupMenuItems: containsAllPrerequisitesDesign?.popupMenuItems ??
          widget.controller.popupMenuItems,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    var field = displayController.item;
    if (field != null && field != {}) {
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
        ? DynamicPopupMenuButton(
            formController: widget.formController,
            controller: displayController,
            formWidgets: formWidgets,
          )
        : SizedBox.shrink();
  }
}
