import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_table/dynamic_table.dart';
import 'package:hana_sdk/core/elements/dynamic_table/dynamic_table_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicTableController extends StatefulWidget {
  final DynamicTableModel controller;
  final FormController formController;

  const DynamicTableController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTableController> createState() => _DynamicTableControllerState();
}

class _DynamicTableControllerState extends State<DynamicTableController> {
  @override
  Widget build(BuildContext context) {
    DynamicTableModel? containsAllPrerequisitesDesign;
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

    // Check for prerequisites
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
                    DynamicTableModel.fromJson(style);
              } else if (style is DynamicTableModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicTableModel.fromJson(style);
              } else if (style is DynamicTableModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }

    // Use containsAllPrerequisitesDesign if available, else fall back to widget.controller
    final displayController = DynamicTableModel(
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      // type: containsAllPrerequisitesDesign?.type ?? widget.controller.type,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      titleTextColor: containsAllPrerequisitesDesign?.titleTextColor ??
          widget.controller.titleTextColor,
      titleBackGroundgColor:
          containsAllPrerequisitesDesign?.titleBackGroundgColor ??
              widget.controller.titleBackGroundgColor,
      titleFontSize: containsAllPrerequisitesDesign?.titleFontSize ??
          widget.controller.titleFontSize,
      titleFontWeight: containsAllPrerequisitesDesign?.titleFontWeight ??
          widget.controller.titleFontWeight,
      titlePadding: containsAllPrerequisitesDesign?.titlePadding ??
          widget.controller.titlePadding,
      valueBackGroundgColor:
          containsAllPrerequisitesDesign?.valueBackGroundgColor ??
              widget.controller.valueBackGroundgColor,
      valueFontSize: containsAllPrerequisitesDesign?.valueFontSize ??
          widget.controller.valueFontSize,
      valueFontWeight: containsAllPrerequisitesDesign?.valueFontWeight ??
          widget.controller.valueFontWeight,
      valuePadding: containsAllPrerequisitesDesign?.valuePadding ??
          widget.controller.valuePadding,
      valueTextColor: containsAllPrerequisitesDesign?.valueTextColor ??
          widget.controller.valueTextColor,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      listOfTitles: containsAllPrerequisitesDesign?.listOfTitles ??
          widget.controller.listOfTitles,
      listOfValues: containsAllPrerequisitesDesign?.listOfValues ??
          widget.controller.listOfValues,
      radius:
          containsAllPrerequisitesDesign?.radius ?? widget.controller.radius,
      tableBorderModel: containsAllPrerequisitesDesign?.tableBorderModel ??
          widget.controller.tableBorderModel,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
    );

    // Return the DynamicText widget with chosen properties
    return !containsAllPrerequisites
        ? DynamicTable(
            controller: displayController,
            formController: widget.formController,
          )
        : const SizedBox.shrink();
  }
}
