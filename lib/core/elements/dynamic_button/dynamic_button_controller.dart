import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button_model.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_text_button.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicButtonController extends StatefulWidget {
  final DynamicButtonModel controller;
  final FormController formController;
  const DynamicButtonController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicButtonController> createState() =>
      _DynamicButtonControllerState();
}

class _DynamicButtonControllerState extends State<DynamicButtonController> {
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
    DynamicButtonModel? containsAllPrerequisitesDesign;
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
                    DynamicButtonModel.fromJson(style);
              } else if (style is DynamicButtonModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicButtonModel.fromJson(style);
              } else if (style is DynamicButtonModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
// Use containsAllPrerequisitesDesign if available, else fall back to widget.controller
    final displayController = DynamicButtonModel(
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      type: containsAllPrerequisitesDesign?.type ?? widget.controller.type,
      width: containsAllPrerequisitesDesign?.width ?? widget.controller.width,
      height:
          containsAllPrerequisitesDesign?.height ?? widget.controller.height,
      color: containsAllPrerequisitesDesign?.color ?? widget.controller.color,
      titleColor: containsAllPrerequisitesDesign?.titleColor ??
          widget.controller.titleColor,
      fontSize: containsAllPrerequisitesDesign?.fontSize ??
          widget.controller.fontSize,
      onClickData: containsAllPrerequisitesDesign?.onClickData ??
          widget.controller.onClickData,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );
    if (!containsAllPrerequisites) {
      if (displayController.type == 'textButton') {
        return DynamicTextButton(
          formController: widget.formController,
          controller: displayController,
          onPressed: () {
            handleDynamicOnClick(displayController, mergedData);
          },
        );
      } else {
        return DynamicButton(
          formController: widget.formController,
          controller: displayController,
          onPressed: () {
            handleDynamicOnClick(displayController, mergedData);
          },
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Future<void> handleDynamicOnClick(
      DynamicButtonModel controller, Map<String, dynamic> mergedData) async {
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
