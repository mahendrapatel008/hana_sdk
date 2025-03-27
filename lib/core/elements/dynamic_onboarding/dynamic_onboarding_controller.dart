import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_onboarding/dynamic_onboarding.dart';
import 'package:hana_sdk/core/elements/dynamic_onboarding/dynamic_onboarding_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicOnBoardingController extends StatefulWidget {
  final DynamicOnboardingSlideModel controller;
  final FormController formController;

  const DynamicOnBoardingController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicOnBoardingController> createState() =>
      _DynamicOnBoardingControllerState();
}

class _DynamicOnBoardingControllerState
    extends State<DynamicOnBoardingController> {
  String locationResult = '';
  Map<String, dynamic> mergedData = {};
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
    DynamicOnboardingSlideModel? containsAllPrerequisitesDesign;
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
                    DynamicOnboardingSlideModel.fromJson(style);
              } else if (style is DynamicOnboardingSlideModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicOnboardingSlideModel.fromJson(style);
              } else if (style is DynamicOnboardingSlideModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicOnboardingSlideModel(
      headerBackgroundColor:
          containsAllPrerequisitesDesign?.headerBackgroundColor ??
              widget.controller.headerBackgroundColor,
      pageBackgroundColor:
          containsAllPrerequisitesDesign?.pageBackgroundColor ??
              widget.controller.pageBackgroundColor,
      finishButtonText: containsAllPrerequisitesDesign?.finishButtonText ??
          widget.controller.finishButtonText,
      skipButtonText: containsAllPrerequisitesDesign?.skipButtonText ??
          widget.controller.skipButtonText,
      controllerColor: containsAllPrerequisitesDesign?.controllerColor ??
          widget.controller.controllerColor,
      skipTextColor: containsAllPrerequisitesDesign?.skipTextColor ??
          widget.controller.skipTextColor,
      loginTextColor: containsAllPrerequisitesDesign?.loginTextColor ??
          widget.controller.loginTextColor,
      speed: containsAllPrerequisitesDesign?.speed ?? widget.controller.speed,
      skipTextSize: containsAllPrerequisitesDesign?.skipTextSize ??
          widget.controller.skipTextSize,
      skipFontWeight: containsAllPrerequisitesDesign?.skipFontWeight ??
          widget.controller.skipFontWeight,
      loginTextSize: containsAllPrerequisitesDesign?.loginTextSize ??
          widget.controller.loginTextSize,
      loginFontWeight: containsAllPrerequisitesDesign?.loginFontWeight ??
          widget.controller.loginFontWeight,
      onClickData: containsAllPrerequisitesDesign?.onClickData ??
          widget.controller.onClickData,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
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
        ? DynamicOnboardingSlider(
            controller: displayController,
            formController: widget.formController,
            formWidgets: formWidgets,
            onPressed: () {
              handleDynamicOnClick(displayController, mergedData);
            },
          )
        : SizedBox.shrink();
  }

  Future<void> handleDynamicOnClick(DynamicOnboardingSlideModel controller,
      Map<String, dynamic> mergedData) async {
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
