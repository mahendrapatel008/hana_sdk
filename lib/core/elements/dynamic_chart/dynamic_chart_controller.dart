import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_circular.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicChartController extends StatefulWidget {
  final DynamicChartModel controller;
  final FormController formController;

  const DynamicChartController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicChartController> createState() => _DynamicChartControllerState();
}

class _DynamicChartControllerState extends State<DynamicChartController> {
  TextEditingController consttext = TextEditingController();

  @override
  void initState() {
    widget.formController.saveFieldName(widget.controller.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DynamicChartModel? containsAllPrerequisitesDesign;
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
                    DynamicChartModel.fromJson(style);
              } else if (style is DynamicChartModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicChartModel.fromJson(style);
              } else if (style is DynamicChartModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }

    // Use containsAllPrerequisitesDesign if available, else fall back to widget.controller
    final displayController = DynamicChartModel(
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      chartType: containsAllPrerequisitesDesign?.chartType ??
          widget.controller.chartType,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      plotAreaBorderWidth:
          containsAllPrerequisitesDesign?.plotAreaBorderWidth ??
              widget.controller.plotAreaBorderWidth,
      xInterval: containsAllPrerequisitesDesign?.xInterval ??
          widget.controller.xInterval,
      yAxisLabelFormat: containsAllPrerequisitesDesign?.yAxisLabelFormat ??
          widget.controller.yAxisLabelFormat,
      hourParsing: containsAllPrerequisitesDesign?.hourParsing ??
          widget.controller.hourParsing,
      enableTooltip: containsAllPrerequisitesDesign?.enableTooltip ??
          widget.controller.enableTooltip,
      trackballBehavior: containsAllPrerequisitesDesign?.trackballBehavior ??
          widget.controller.trackballBehavior,
      tooltipColor: containsAllPrerequisitesDesign?.tooltipColor ??
          widget.controller.tooltipColor,
      sharedTooltip: containsAllPrerequisitesDesign?.sharedTooltip ??
          widget.controller.sharedTooltip,
      zoomSelection: containsAllPrerequisitesDesign?.zoomSelection ??
          widget.controller.zoomSelection,
      enablePanning: containsAllPrerequisitesDesign?.enablePanning ??
          widget.controller.enablePanning,
      enablePinching: containsAllPrerequisitesDesign?.enablePinching ??
          widget.controller.enablePinching,
      enableDoubleTapZoom:
          containsAllPrerequisitesDesign?.enableDoubleTapZoom ??
              widget.controller.enableDoubleTapZoom,
      zoomMode: containsAllPrerequisitesDesign?.zoomMode ??
          widget.controller.zoomMode,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      manualXaxis: containsAllPrerequisitesDesign?.manualXaxis ??
          widget.controller.manualXaxis,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
      xLabel:
          containsAllPrerequisitesDesign?.xLabel ?? widget.controller.xLabel,
      yLabel:
          containsAllPrerequisitesDesign?.yLabel ?? widget.controller.yLabel,
    );
    // Select chart widget based on chartType
    if (!containsAllPrerequisites) {
      if (displayController.chartType == "stakeArea" ||
          displayController.chartType == "stepArea" ||
          displayController.chartType == "stepLine" ||
          displayController.chartType == "bubble" ||
          displayController.chartType == "scatter" ||
          displayController.chartType == "splineArea" ||
          displayController.chartType == "spline" ||
          displayController.chartType == "column" ||
          displayController.chartType == "line" ||
          displayController.chartType == "bar" ||
          displayController.chartType == "area" ||
          displayController.chartType == "stackedColumnArea") {
        return DynamicStackedAreaChart(
          controller: displayController,
          formController: widget.formController,
        );
      } else if (displayController.chartType == "pie" ||
          displayController.chartType == "doughnut" ||
          displayController.chartType == "radialBar") {
        return DynamicCircularChart(
          controller: displayController,
          formController: widget.formController,
        );
      }
      return DynamicCircularChart(
        controller: displayController,
        formController: widget.formController,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
