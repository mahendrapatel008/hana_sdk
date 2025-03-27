import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_container/dynamic_container.dart';
import 'package:hana_sdk/core/elements/dynamic_container/dynamic_container_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicContainerController extends StatefulWidget {
  final DynamicContainerModel controller;
  final FormController formController;

  const DynamicContainerController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicContainerController> createState() =>
      _DynamicContainerControllerState();
}

class _DynamicContainerControllerState
    extends State<DynamicContainerController> {
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
    DynamicContainerModel? containsAllPrerequisitesDesign;
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
                    DynamicContainerModel.fromJson(style);
              } else if (style is DynamicContainerModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicContainerModel.fromJson(style);
              } else if (style is DynamicContainerModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final DynamicContainerModel displayController = DynamicContainerModel(
      width: containsAllPrerequisitesDesign?.width ?? widget.controller.width,
      elevation: containsAllPrerequisitesDesign?.elevation ??
          widget.controller.elevation,
      shadowColor: containsAllPrerequisitesDesign?.shadowColor ??
          widget.controller.shadowColor,
      shadowOffset: containsAllPrerequisitesDesign?.shadowOffset ??
          widget.controller.shadowOffset,
      spreadRadius: containsAllPrerequisitesDesign?.spreadRadius ??
          widget.controller.spreadRadius,
      height:
          containsAllPrerequisitesDesign?.height ?? widget.controller.height,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      onClickData: containsAllPrerequisitesDesign?.onClickData ??
          widget.controller.onClickData,
      margin:
          containsAllPrerequisitesDesign?.margin ?? widget.controller.margin,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      padding:
          containsAllPrerequisitesDesign?.padding ?? widget.controller.padding,
      backGroundColor: containsAllPrerequisitesDesign?.backGroundColor ??
          widget.controller.backGroundColor,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      showBorder: containsAllPrerequisitesDesign?.showBorder ??
          widget.controller.showBorder,
      borderWidth: containsAllPrerequisitesDesign?.borderWidth ??
          widget.controller.borderWidth,
      isCenter: containsAllPrerequisitesDesign?.isCenter ??
          widget.controller.isCenter,
      url: containsAllPrerequisitesDesign?.url ?? widget.controller.url,
      isUrlLauncher: containsAllPrerequisitesDesign?.isUrlLauncher ??
          widget.controller.isUrlLauncher,
      gradient: containsAllPrerequisitesDesign?.gradient ??
          widget.controller.gradient,
      fit: containsAllPrerequisitesDesign?.fit ?? widget.controller.fit,
      imgUrl:
          containsAllPrerequisitesDesign?.imgUrl ?? widget.controller.imgUrl,
      imageOpacity: containsAllPrerequisitesDesign?.imageOpacity ??
          widget.controller.imageOpacity,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
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
        ? DynamicContainer(
            formWidgets: formWidgets,
            formController: widget.formController,
            model: displayController,
            onPressed: () {
              handleDynamicOnClick(displayController, mergedData);
            },
          )
        : SizedBox.shrink();
  }

  Future<void> handleDynamicOnClick(
      DynamicContainerModel controller, Map<String, dynamic> mergedData) async {
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
