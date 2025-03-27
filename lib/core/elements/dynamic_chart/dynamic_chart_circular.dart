import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DynamicCircularChart extends StatefulWidget {
  final DynamicChartModel controller;
  final FormController formController;

  const DynamicCircularChart({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicCircularChart> createState() => _DynamicCircularChartState();
}

class _DynamicCircularChartState extends State<DynamicCircularChart> {
  List<ChartData>? itemsData;

  @override
  void initState() {
    super.initState();
  }

  void _initState(String resolvedText) {
    try {
      final dynamic decodedText = jsonDecode(resolvedText);

      if (decodedText is Map<String, dynamic>) {
        itemsData = DynamicChartModel.fromJson(decodedText).items;
      } else if (decodedText is List) {
        itemsData =
            decodedText.map((item) => ChartData.fromJson(item)).toList();
      } else {
        itemsData = widget.controller.items;
      }
    } catch (e) {
      // Use items directly from the controller if no dynamic data
      print("Error decoding resolvedText: $e");
      itemsData = widget.controller.items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: resolveDynamicValue(widget.controller.dataKey,
            widget.controller.label, widget.formController),
        builder: (context, snapshot) {
          final resolvedText =
              snapshot.data ?? widget.controller.label ?? '...';
          _initState(resolvedText);
          return itemsData == null
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: itemsData!.map((chartData) {
                    return Column(
                      children: [
                        Text("${chartData.title}"),
                        SfCircularChart(
                          legend: const Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            position: LegendPosition.bottom,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: _getCircularSeriesForOneChart(chartData),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                );
        });
  }

  List<CircularSeries<ChartInnerData, String>> _getCircularSeriesForOneChart(
      ChartData chartData) {
    if (widget.controller.chartType == "pie") {
      return [_getPieSeriesA(chartData)];
    } else if (widget.controller.chartType == "doughnut") {
      return [_getDoughnutSeriesA(chartData)];
    } else if (widget.controller.chartType == "radialBar") {
      return [_getRadialBarSeriesA(chartData)];
    } else {
      return []; // Return empty list if chart type doesn't match
    }
  }

  PieSeries<ChartInnerData, String> _getPieSeriesA(ChartData chartData) {
    return PieSeries<ChartInnerData, String>(
      dataSource: chartData.items,
      xValueMapper: (ChartInnerData data, _) => data.xValue.toString(),
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      dataLabelMapper: (ChartInnerData data, _) => data.xValue.toString(),
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        textStyle: TextStyle(fontSize: 12),
      ),
      name: chartData.title,
      strokeColor: chartData.color ?? Colors.transparent,
    );
  }

  DoughnutSeries<ChartInnerData, String> _getDoughnutSeriesA(
      ChartData chartData) {
    return DoughnutSeries<ChartInnerData, String>(
      dataSource: chartData.items,
      xValueMapper: (ChartInnerData data, _) => data.xValue.toString(),
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      dataLabelMapper: (ChartInnerData data, _) => data.xValue.toString(),
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        textStyle: TextStyle(fontSize: 12),
      ),
      name: chartData.title,
      strokeColor: chartData.color ?? Colors.transparent,
    );
  }

  RadialBarSeries<ChartInnerData, String> _getRadialBarSeriesA(
      ChartData chartData) {
    return RadialBarSeries<ChartInnerData, String>(
      dataSource: chartData.items,
      xValueMapper: (ChartInnerData data, _) => data.xValue.toString(),
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      dataLabelMapper: (ChartInnerData data, _) => data.xValue.toString(),
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        textStyle: TextStyle(fontSize: 12),
      ),
      name: chartData.title,
    );
  }
}
