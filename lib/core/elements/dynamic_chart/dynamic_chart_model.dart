import 'package:flutter/material.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DynamicChartModel {
  DynamicChartModel({
    this.items,
    this.chartType,
    this.name,
    this.dataKey,
    this.id,
    this.label,
    this.xLabel,
    this.yLabel,
    this.plotAreaBorderWidth,
    this.xInterval,
    this.yAxisLabelFormat,
    this.hourParsing,
    this.manualXaxis,
    this.isHideAndShow,
    this.enableTooltip,
    this.trackballBehavior,
    this.tooltipColor,
    this.sharedTooltip,
    this.zoomSelection,
    this.enablePanning,
    this.enablePinching,
    this.enableDoubleTapZoom,
    this.zoomMode,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  final List<ChartData>? items;
  final String? chartType;
  final String? name;
  final String? id;
  final String? xLabel;
  final String? yLabel;
  final String? label;
  final String? dataKey;
  final double? plotAreaBorderWidth;
  final double? xInterval;
  final String? yAxisLabelFormat;
  final bool? hourParsing;
  final bool? manualXaxis;
  final bool? isHideAndShow;
  final bool? enableTooltip;
  final bool? trackballBehavior;
  final Color? tooltipColor;
  final bool? sharedTooltip;
  final bool? zoomSelection;
  final bool? enablePanning;
  final bool? enablePinching;
  final bool? enableDoubleTapZoom;
  final ZoomMode? zoomMode;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  factory DynamicChartModel.fromJson(Map<String, dynamic> json) {
    // Initialize formSections list based on presence of 'items' or 'data'
    List<ChartData>? formSections;

    if (json.containsKey('items') &&
        json['items'] is List &&
        (json['items'] as List).isNotEmpty) {
      formSections = (json['items'] as List).map((sectionJson) {
        return ChartData.fromJson(sectionJson);
      }).toList();
    } else if (json.containsKey('data') &&
        json['data'] is List &&
        (json['data'] as List).isNotEmpty) {
      formSections = [
        ChartData(
          title: json['title'],
          color: hexToColor(json["color"]),
          opacity: double.tryParse((json['opacity']).toString()) ?? 1.0,
          items: (json['data'] as List)
              .map((dataJson) => ChartInnerData.fromJson(dataJson))
              .toList(),
        )
      ];
    } else {
      formSections = null;
    }

    List<PrerequisiteModel>? prerequisiteList;
    if (json['prerequisite'] != null) {
      var prerequisites = json['prerequisite'] as List;
      prerequisiteList = prerequisites
          .map((item) => PrerequisiteModel.fromJson(item))
          .toList();
    }
    List<HanaPrerequisiteModel>? hanaPrerequisiteDesignList;
    if (json['hanaPrerequisiteDesign'] != null) {
      var hanaPrerequisiteDesigns = json['hanaPrerequisiteDesign'] as List;
      hanaPrerequisiteDesignList = hanaPrerequisiteDesigns
          .map((item) => HanaPrerequisiteModel.fromJson(item))
          .toList();
    }
    return DynamicChartModel(
      items: formSections,
      chartType: json['chartType'],
      name: json['name'],
      dataKey: json['dataKey'],
      xLabel: json['xLabel'],
      yLabel: json['yLabel'],
      id: json['id'],
      label: json['label'],
      isHideAndShow: json["isHideAndShow"],
      plotAreaBorderWidth: json['plotAreaBorderWidth'] != null
          ? double.tryParse(json['plotAreaBorderWidth'].toString())
          : null,
      xInterval: json['xInterval'] != null
          ? double.tryParse(json['xInterval'].toString())
          : null,
      yAxisLabelFormat: json['yAxisLabelFormat'],
      hourParsing: json['hourParsing'],
      manualXaxis: json['manualXaxis'],
      enableTooltip: json['enableTooltip'],
      trackballBehavior: json['trackballBehavior'],
      tooltipColor: json['tooltipColor'] != null
          ? hexToColor(json['tooltipColor'])
          : null,
      sharedTooltip: json['sharedTooltip'],
      zoomSelection: json['zoomSelection'],
      enablePanning: json['enablePanning'],
      enablePinching: json['enablePinching'],
      enableDoubleTapZoom: json['enableDoubleTapZoom'],
      zoomMode: json['zoomMode'] != null
          ? json['zoomMode'] == "x"
              ? ZoomMode.x
              : json['zoomMode'] == "y"
                  ? ZoomMode.y
                  : ZoomMode.x
          : null,
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }
}

class ChartData {
  final String? title;

  final Color? color;
  final double? opacity;
  final List<ChartInnerData>? items;

  ChartData({
    this.title,
    this.color,
    this.opacity,
    this.items,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    var formSections = (json['data'] != null && json['data'] is List)
        ? (json['data'] as List).map((sectionJson) {
            return ChartInnerData.fromJson(sectionJson);
          }).toList()
        : <ChartInnerData>[];
    return ChartData(
      title: json['title'] ?? '2024',
      opacity: double.parse((json['opacity'] ?? '1').toString()),
      items: formSections,
      color: hexToColor(json["color"]),
    );
  }
}

class ChartInnerData {
  final String? xValue;
  final double? yValue;

  ChartInnerData({
    this.xValue,
    this.yValue,
  });

  factory ChartInnerData.fromJson(Map<String, dynamic> json) {
    return ChartInnerData(
      xValue: json['xValue'] ?? '0',
      yValue: json['yValue'] != null
          ? double.tryParse(json['yValue'].toString())
          : null,
    );
  }
}
