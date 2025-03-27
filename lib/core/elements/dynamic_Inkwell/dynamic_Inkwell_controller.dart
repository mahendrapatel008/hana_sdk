import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_Inkwell/dynamic_Inkwell.dart';
import 'package:hana_sdk/core/elements/dynamic_Inkwell/dynamic_Inkwell_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicInkWellController extends StatefulWidget {
  final DynamicInkWellModel controller;
  final FormController formController;

  const DynamicInkWellController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicInkWellController> createState() =>
      _DynamicInkWellControllerState();
}

class _DynamicInkWellControllerState extends State<DynamicInkWellController> {
  String locationResult = '';
  Map<String, dynamic> mergedData = {};
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
    DynamicInkWellModel? containsAllPrerequisitesDesign;
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
                    DynamicInkWellModel.fromJson(style);
              } else if (style is DynamicInkWellModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicInkWellModel.fromJson(style);
              } else if (style is DynamicInkWellModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicInkWellModel(
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      onTap: containsAllPrerequisitesDesign?.onTap ?? widget.controller.onTap,
      onDoubleTap: containsAllPrerequisitesDesign?.onDoubleTap ??
          widget.controller.onDoubleTap,
      onHover:
          containsAllPrerequisitesDesign?.onHover ?? widget.controller.onHover,
      onLongPress: containsAllPrerequisitesDesign?.onLongPress ??
          widget.controller.onLongPress,
      focusColor: containsAllPrerequisitesDesign?.focusColor ??
          widget.controller.focusColor,
      highlightColor: containsAllPrerequisitesDesign?.highlightColor ??
          widget.controller.highlightColor,
      hoverColor: containsAllPrerequisitesDesign?.hoverColor ??
          widget.controller.hoverColor,
      hoverDuration: containsAllPrerequisitesDesign?.hoverDuration ??
          widget.controller.hoverDuration,
      splashColor: containsAllPrerequisitesDesign?.splashColor ??
          widget.controller.splashColor,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    Widget? formWidgets;
    var field = displayController.items;
    var formElement = ApiFormElements.fromJson({
      "type": field["type"],
      "items": field,
    });
    formElement.formController = widget.formController;
    var apiElementController =
        ApiElementController(formSectionsElements: formElement);
    formWidgets = apiElementController.buildFormElement();

    return !containsAllPrerequisites
        ? DynamicInkWell(
            formWidgets: formWidgets,
            model: displayController,
            formController: widget.formController,
            onPressed: (onClickData) {
              handleDynamicOnClick(displayController, mergedData, onClickData);
            },
          )
        : SizedBox.shrink();
  }

  Future<void> handleDynamicOnClick(DynamicInkWellModel controller,
      Map<String, dynamic> mergedData, OnClickData? onClickData) async {
    final onClickHandler = DynamicOnClickHandler(
      onClickData: onClickData,
      formController: widget.formController,
      dName: controller.name,
      mergedData: mergedData,
      context: context,
      hanaPrerequisiteDesign: controller.hanaPrerequisiteDesign,
      locationResult: locationResult,
    );

    await onClickHandler.handleDynamicClick();
  }
}
