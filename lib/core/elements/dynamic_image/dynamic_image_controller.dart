import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicImageController extends StatefulWidget {
  final DynamicImageModel controller;
  final FormController formController;

  const DynamicImageController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicImageController> createState() => _DynamicImageControllerState();
}

class _DynamicImageControllerState extends State<DynamicImageController> {
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

    DynamicImageModel? containsAllPrerequisitesDesign;
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
                    DynamicImageModel.fromJson(style);
              } else if (style is DynamicImageModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicImageModel.fromJson(style);
              } else if (style is DynamicImageModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }

    final DynamicImageModel displayController = DynamicImageModel(
      width: containsAllPrerequisitesDesign?.width ?? widget.controller.width,
      height:
          containsAllPrerequisitesDesign?.height ?? widget.controller.height,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      margin:
          containsAllPrerequisitesDesign?.margin ?? widget.controller.margin,
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
      imgUrl:
          containsAllPrerequisitesDesign?.imgUrl ?? widget.controller.imgUrl,
      fit: containsAllPrerequisitesDesign?.fit ?? widget.controller.fit,
      placeholder: containsAllPrerequisitesDesign?.placeholder ??
          widget.controller.placeholder,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      onClickData: containsAllPrerequisitesDesign?.onClickData ??
          widget.controller.onClickData,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
    );

    return !containsAllPrerequisites
        ? DynamicImage(
            formController: widget.formController,
            controller: displayController,
            onPressed: () {
              handleDynamicOnClick(displayController, mergedData);
            },
          )
        : SizedBox.shrink();
  }

  Future<void> handleDynamicOnClick(
      DynamicImageModel controller, Map<String, dynamic> mergedData) async {
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
