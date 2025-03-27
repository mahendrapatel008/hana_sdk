import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DynamicStackedAreaChart extends StatefulWidget {
  final DynamicChartModel controller;
  final FormController formController;

  const DynamicStackedAreaChart({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicStackedAreaChart> createState() =>
      _DynamicStackedAreaChartState();
}

class _DynamicStackedAreaChartState extends State<DynamicStackedAreaChart> {
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

  String parseTimeToHour(String timeString) {
    try {
      final parts = timeString.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      // If there are no minutes, return only the hour
      if (minutes == 00) {
        return hours.toString(); // Return hour as integer
      }
      return "$hours:$minutes"; // Convert minutes to fractional hours
    } catch (e) {
      return '0'; // Fallback to 0 on parse error
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
          return SfCartesianChart(
            plotAreaBorderWidth: widget.controller.plotAreaBorderWidth ?? 0,
            legend: Legend(
              isVisible: widget.controller.isHideAndShow ?? true,
              overflowMode: LegendItemOverflowMode.scroll,
            ),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                  text: widget.controller.xLabel,
                  textStyle: TextStyle(fontSize: 12),
                  alignment: ChartAlignment.far),
              majorGridLines: MajorGridLines(width: 0),
              interval: widget.controller.xInterval,
              labelStyle: const TextStyle(fontSize: 12),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                  text: widget.controller.yLabel,
                  textStyle: TextStyle(fontSize: 12),
                  alignment: ChartAlignment.far),
              axisLine: const AxisLine(width: 0),
              labelFormat: widget.controller.yAxisLabelFormat ?? '{value}',
              majorTickLines: const MajorTickLines(size: 0),
            ),
            enableAxisAnimation: true,
            zoomPanBehavior: ZoomPanBehavior(
              enableSelectionZooming: widget.controller.zoomSelection ?? false,
              enablePanning: widget.controller.enablePanning ?? false,
              enablePinching: widget.controller.enablePinching ?? false,
              enableDoubleTapZooming:
                  widget.controller.enableDoubleTapZoom ?? false,
              zoomMode: widget.controller.zoomMode ?? ZoomMode.x,
            ),
            series: widget.controller.chartType == "stakeArea"
                ? _getStackedColumnSeries(itemsData ?? [])
                : widget.controller.chartType == "bar"
                    ? _getBarSeries(itemsData ?? [])
                    : widget.controller.chartType == "line"
                        ? _getLineSeries(itemsData ?? [])
                        : widget.controller.chartType == "column"
                            ? _getColumnSeries(itemsData ?? [])
                            : widget.controller.chartType == "spline"
                                ? _getSplineSeries(itemsData ?? [])
                                : widget.controller.chartType == "splineArea"
                                    ? _getSplineAreaSeries(itemsData ?? [])
                                    : widget.controller.chartType == "scatter"
                                        ? _getScatterAreaSeries(itemsData ?? [])
                                        : widget.controller.chartType ==
                                                "bubble"
                                            ? _getBubbleAreaSeries(
                                                itemsData ?? [])
                                            : widget.controller.chartType ==
                                                    "stepLine"
                                                ? _getStepLineSeries(
                                                    itemsData ?? [])
                                                : widget.controller.chartType ==
                                                        "stepArea"
                                                    ? _getStepAreaSeries(
                                                        itemsData ?? [])
                                                    : widget.controller
                                                                .chartType ==
                                                            "stackedColumnArea"
                                                        ? _getStackedColumnAreaSeries(
                                                            itemsData ?? [])
                                                        : widget.controller
                                                                    .chartType ==
                                                                "area"
                                                            ? _getAreaSeries(
                                                                widget.controller
                                                                        .items ??
                                                                    [])
                                                            : _getStackedColumnSeries(
                                                                widget.controller
                                                                        .items ??
                                                                    []),
            tooltipBehavior: widget.controller.enableTooltip == true
                ? TooltipBehavior(
                    enable: widget.controller.enableTooltip ?? true,
                    color: widget.controller.tooltipColor ?? Colors.blue,
                    shared: widget.controller.sharedTooltip ?? false,
                    format:
                        '${widget.controller.xLabel}: point.x \n${widget.controller.yLabel}: point.y', // Custom format for tooltip
                  )
                : null,
            // crosshairBehavior: CrosshairBehavior(
            //   enable: true, // Enable crosshair
            //   activationMode:
            //       ActivationMode.singleTap, // Trigger crosshair on single tap
            //   shouldAlwaysShow: false, // Crosshair visibility on chart load
            //   lineWidth: 1, // Width of crosshair line
            //   lineType: CrosshairLineType.both, // Show crosshair lines on both axes
            //   lineDashArray: [4, 4], // Dotted line pattern
            // ),
            trackballBehavior: widget.controller.trackballBehavior == true
                ? TrackballBehavior(
                    enable: true, // Enable trackball
                    activationMode: ActivationMode
                        .singleTap, // Trigger trackball on single tap
                    tooltipSettings: InteractiveTooltip(
                      color: Colors.black,
                      format:
                          '${widget.controller.xLabel}: point.x \n${widget.controller.yLabel}: point.y',
                      textStyle: TextStyle(color: Colors.white),
                    ), // Tooltip styling
                  )
                : null,
            // annotations: <CartesianChartAnnotation>[
            //   CartesianChartAnnotation(
            //     widget: const Text(
            //       'Custom Annotation',
            //       style: TextStyle(color: Colors.red, fontSize: 14),
            //     ),
            //     coordinateUnit: CoordinateUnit.point,
            //     x: 'CustomXValue', // X-axis value
            //     y: 50, // Y-axis value
            //   ),
            // ],
            // axes: <ChartAxis>[
            //   NumericAxis(
            //     opposedPosition: true, // Display on the opposite side
            //     name: 'SecondaryAxis',
            //     interval: 100,
            //   )
            // ],
          );
        });
  }

  List<StackedAreaSeries<ChartInnerData, String>> _getStackedColumnSeries(
      List<ChartData> hourlyChartData) {
    List<StackedAreaSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getStackedColumnSeriesA(element));
    }
    return data;
  }

  StackedAreaSeries<ChartInnerData, String> _getStackedColumnSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return StackedAreaSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
      // gradient: LinearGradient(
      //   colors: [
      //     hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1),
      //     Colors.blue.withOpacity(0.5), // Customize this color
      //   ],
      //   begin: Alignment.bottomCenter,
      //   end: Alignment.topCenter,
      // ),
    );
  }

  List<BarSeries<ChartInnerData, String>> _getBarSeries(
      List<ChartData> hourlyChartData) {
    List<BarSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getBarSeriesA(element));
    }
    return data;
  }

  BarSeries<ChartInnerData, String> _getBarSeriesA(ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return BarSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<LineSeries<ChartInnerData, String>> _getLineSeries(
      List<ChartData> hourlyChartData) {
    List<LineSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getLineSeriesA(element));
    }
    return data;
  }

  LineSeries<ChartInnerData, String> _getLineSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return LineSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<ColumnSeries<ChartInnerData, String>> _getColumnSeries(
      List<ChartData> hourlyChartData) {
    List<ColumnSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getColumnSeriesA(element));
    }
    return data;
  }

  ColumnSeries<ChartInnerData, String> _getColumnSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return ColumnSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<SplineSeries<ChartInnerData, String>> _getSplineSeries(
      List<ChartData> hourlyChartData) {
    List<SplineSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getSplineSeriesA(element));
    }
    return data;
  }

  SplineSeries<ChartInnerData, String> _getSplineSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return SplineSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<SplineAreaSeries<ChartInnerData, String>> _getSplineAreaSeries(
      List<ChartData> hourlyChartData) {
    List<SplineAreaSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getSplineAreaSeriesA(element));
    }
    return data;
  }

  SplineAreaSeries<ChartInnerData, String> _getSplineAreaSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return SplineAreaSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<ScatterSeries<ChartInnerData, String>> _getScatterAreaSeries(
      List<ChartData> hourlyChartData) {
    List<ScatterSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getScatterAreaSeriesA(element));
    }
    return data;
  }

  ScatterSeries<ChartInnerData, String> _getScatterAreaSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return ScatterSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<BubbleSeries<ChartInnerData, String>> _getBubbleAreaSeries(
      List<ChartData> hourlyChartData) {
    List<BubbleSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getBubbleAreaSeriesA(element));
    }
    return data;
  }

  BubbleSeries<ChartInnerData, String> _getBubbleAreaSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return BubbleSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<StepLineSeries<ChartInnerData, String>> _getStepLineSeries(
      List<ChartData> hourlyChartData) {
    List<StepLineSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getStepLineSeriesA(element));
    }
    return data;
  }

  StepLineSeries<ChartInnerData, String> _getStepLineSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return StepLineSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<StepAreaSeries<ChartInnerData, String>> _getStepAreaSeries(
      List<ChartData> hourlyChartData) {
    List<StepAreaSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getStepAreaSeriesA(element));
    }
    return data;
  }

  StepAreaSeries<ChartInnerData, String> _getStepAreaSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return StepAreaSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<StackedColumnSeries<ChartInnerData, String>> _getStackedColumnAreaSeries(
      List<ChartData> hourlyChartData) {
    List<StackedColumnSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getStackedColumnAreaSeriesA(element));
    }
    return data;
  }

  StackedColumnSeries<ChartInnerData, String> _getStackedColumnAreaSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return StackedColumnSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
    );
  }

  List<AreaSeries<ChartInnerData, String>> _getAreaSeries(
      List<ChartData> hourlyChartData) {
    // Set opacity for the color of each series

    List<AreaSeries<ChartInnerData, String>> data = [];
    for (var element in hourlyChartData) {
      data.add(_getAreaSeriesA(element));
    }
    return data;
  }

  AreaSeries<ChartInnerData, String> _getAreaSeriesA(
      ChartData hourlyChartData) {
    Color colorWithOpacity =
        hourlyChartData.color!.withOpacity(hourlyChartData.opacity ?? 1);
    return AreaSeries<ChartInnerData, String>(
      dataSource: hourlyChartData.items,
      xValueMapper: (ChartInnerData data, _) {
        if (widget.controller.hourParsing == true) {
          if (data.xValue is String) {
            // Parse the time string into hours and return it as a string
            final hours = parseTimeToHour(data.xValue.toString());
            return hours.toString();
            // .toStringAsFixed(1); // Convert num to string with 1 decimal
          } else {
            return data.xValue
                .toString(); // Fallback to the original string value
          }
        } else {
          return data.xValue
              .toString(); // Fallback to the original string value
        }
      },
      yValueMapper: (ChartInnerData data, _) => data.yValue,
      name: hourlyChartData.title,
      color: colorWithOpacity,
      // color: hourlyChartData.color,
    );
  }

  // List<PieSeries<ChartInnerData, String>> _getPieSeries(
  //     List<ChartData> hourlyChartData) {
  //   List<PieSeries<ChartInnerData, String>> data = [];
  //   for (var element in hourlyChartData) {
  //     data.add(_getPieSeriesA(element));
  //   }
  //   return data;
  // }

  // PieSeries<ChartInnerData, String> _getPieSeriesA(ChartData hourlyChartData) {
  //   return PieSeries<ChartInnerData, String>(
  //     dataSource: hourlyChartData.items,
  //     xValueMapper: (ChartInnerData data, _) => data.xValue.toString(),
  //     yValueMapper: (ChartInnerData data, _) => data.yValue,
  //     name: hourlyChartData.title,
  //     strokeColor: hourlyChartData.color ?? Colors.transparent,
  //   );
  // }

  // List<RangeAreaSeries<ChartInnerData, String>> _getRangeAreaSeries(
  //     List<ChartData> hourlyChartData) {
  //   List<RangeAreaSeries<ChartInnerData, String>> data = [];
  //   for (var element in hourlyChartData) {
  //     data.add(_getRangeAreaSeriesA(element));
  //   }
  //   return data;
  // }

  // RangeAreaSeries<ChartInnerData, String> _getRangeAreaSeriesA(
  //     ChartData hourlyChartData) {
  //   return RangeAreaSeries<ChartInnerData, String>(
  //     dataSource: hourlyChartData.items,
  //     xValueMapper: (ChartInnerData data, _) => data.xValue.toString(),
  //     // yValueMapper: (ChartInnerData data, _) => data.yValue,
  //     name: hourlyChartData.title,
  //     color: hourlyChartData.color,
  //     highValueMapper: (ChartInnerData datum, int index) {},
  //     lowValueMapper: (ChartInnerData datum, int index) {},
  //   );
  // }
}
