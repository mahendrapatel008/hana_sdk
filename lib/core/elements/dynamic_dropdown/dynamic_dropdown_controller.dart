import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_dropdown/dynamic_dropdown.dart';
import 'package:hana_sdk/core/elements/dynamic_dropdown/dynamic_dropdown_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicDropdownController extends StatefulWidget {
  final DynamicDropdownModel controller;
  final FormController formController;

  const DynamicDropdownController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicDropdownController> createState() =>
      _DynamicDropdownControllerState();
}

class _DynamicDropdownControllerState extends State<DynamicDropdownController> {
  TextEditingController consttext = TextEditingController();
  String locationResult = '';
  Map<String, dynamic> mergedData = {};
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
    DynamicDropdownModel? containsAllPrerequisitesDesign;
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
                    DynamicDropdownModel.fromJson(style);
              } else if (style is DynamicDropdownModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicDropdownModel.fromJson(style);
              } else if (style is DynamicDropdownModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicDropdownModel(
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      placeholder: containsAllPrerequisitesDesign?.placeholder ??
          widget.controller.placeholder,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      backGroundColor: containsAllPrerequisitesDesign?.backGroundColor ??
          widget.controller.backGroundColor,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      borderWidth: containsAllPrerequisitesDesign?.borderWidth ??
          widget.controller.borderWidth,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      textColor: containsAllPrerequisitesDesign?.textColor ??
          widget.controller.textColor,
      textSize: containsAllPrerequisitesDesign?.textSize ??
          widget.controller.textSize,
      textWeight: containsAllPrerequisitesDesign?.textWeight ??
          widget.controller.textWeight,
      required: containsAllPrerequisitesDesign?.required ??
          widget.controller.required,
      validator: containsAllPrerequisitesDesign?.validator ??
          widget.controller.validator,
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      readOnly: containsAllPrerequisitesDesign?.readOnly ??
          widget.controller.readOnly,
      isId: containsAllPrerequisitesDesign?.isId ?? widget.controller.isId,
      onClickData: containsAllPrerequisitesDesign?.onClickData ??
          widget.controller.onClickData,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
    );

    return !containsAllPrerequisites
        ? DynamicDropdown(
            controller: displayController,
            formController: widget.formController,
            onPressed: () {
              handleDynamicOnClick(displayController, mergedData);
            },
          )
        : SizedBox.shrink();
  }

  Future<void> handleDynamicOnClick(
      DynamicDropdownModel controller, Map<String, dynamic> mergedData) async {
    final onClickHandler = DynamicOnClickHandler(
      onClickData: controller.onClickData,
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
