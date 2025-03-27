import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/elements/dynamic_table/dynamic_table_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicTable extends StatefulWidget {
  final DynamicTableModel controller;
  final FormController formController;

  const DynamicTable({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTable> createState() => _DynamicTableState();
}

class _DynamicTableState extends State<DynamicTable> {
  String locationResult = '';
  String time = '';
  @override
  void initState() {
    // widget.formController.saveFieldName(widget.controller.name);
    // if (widget.controller.showLocation == true) {
    //   fetchLocation();
    // }
    // if (widget.controller.showTime == true) {
    //   generateCurrentTime();
    // }
    super.initState();
  }
  // void fetchLocation() async {
  //   await fetchCurrentLocation(
  //       widget.controller.addressFormate ?? "{name} {locality}, {country}");
  //   setState(() {
  //     locationResult = widget.controller.locationFormate ??
  //         "{latitude} {longitude} {locationAddress}";
  //     locationResult = locationResult.replaceAll(
  //         "{latitude}", SharedPrefs().latitude.toString());
  //     locationResult = locationResult.replaceAll(
  //         "{longitude}", SharedPrefs().longitude.toString());
  //     locationResult = locationResult.replaceAll(
  //         "{locationAddress}", SharedPrefs().locationAddress.toString());
  //     // locationResult = newLocation; // Update the locationResult
  //   });
  // }

  // void generateCurrentTime() {
  //   final now = DateTime.now();
  //   final timeFormatter =
  //       DateFormat('h:mm a'); // 'h' is for 12-hour format, 'a' is for AM/PM
  //   setState(() {
  //     time = timeFormatter.format(now).toString();
  //   });
  //   // return timeFormatter.format(now);
  // }

  @override
  Widget build(BuildContext context) {
    String labelText =
        widget.controller.label ?? ''; // Default to empty if label is null
    String dynamicKey = labelText
        .replaceAll('{', '')
        .replaceAll('}', ''); // Process key for dynamic lookup
    List<List<String>>? dynamicValue;
    String? rawValue;
    if (labelText.contains("{")) {
      rawValue = getDynamicValue(dynamicKey); // Assuming this returns a String?
    } else {
      rawValue = getDynamicValue(widget.controller.dataKey);
    }

    // Example: Parse rawValue into List<List<String>> if needed
    dynamicValue = rawValue!
        .split(';') // Split by row delimiter (e.g., ';' for rows)
        .map((row) => row.split(',')) // Split each row into a list of strings
        .toList();
      return Table(
      border: widget.controller.tableBorderModel != null
          ? TableBorder.symmetric(
              inside: BorderSide(
                  color: hexToColor(widget
                          .controller.tableBorderModel?.insideBorderColor) ??
                      Colors.black,
                  width: widget.controller.tableBorderModel?.insideBorderWidth
                          ?.toDouble() ??
                      1),
              outside: BorderSide(
                  color: hexToColor(widget
                          .controller.tableBorderModel?.outsideBorderColor) ??
                      Colors.black,
                  width: widget.controller.tableBorderModel?.outsideBorderWidth
                          ?.toDouble() ??
                      1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    widget.controller.radius?.topLeft.toDouble() ?? 0),
                topRight: Radius.circular(
                    widget.controller.radius?.topRight.toDouble() ?? 0),
                bottomLeft: Radius.circular(
                    widget.controller.radius?.bottomLeft.toDouble() ?? 0),
                bottomRight: Radius.circular(
                    widget.controller.radius?.bottomRight.toDouble() ?? 0),
              ),
            )
          : TableBorder.symmetric(),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: hexToColor(widget.controller.titleBackGroundgColor) ??
                Colors.amber,
          ),
          children: List.generate(
            widget.controller.listOfTitles?.length ?? 0,
            (index) => Padding(
              padding: EdgeInsets.only(
                left: widget.controller.titlePadding?.left?.toDouble() ?? 0,
                right: widget.controller.titlePadding?.right?.toDouble() ?? 0,
                top: widget.controller.titlePadding?.top?.toDouble() ?? 0,
                bottom: widget.controller.titlePadding?.bottom?.toDouble() ?? 0,
              ),
              child: Center(
                child: Text(
                  widget.controller.listOfTitles?[index] ?? '',
                  style: TextStyle(
                    fontSize: widget.controller.titleFontSize?.toDouble(),
                    fontWeight:
                        stringToFontWeight(widget.controller.titleFontWeight) ??
                            FontWeight.bold,
                    color: hexToColor(widget.controller.titleTextColor),
                  ),
                ),
              ),
            ),
          ),
        ),
        ...(dynamicValue).map((data) {
          return TableRow(
            decoration: BoxDecoration(
              color: hexToColor(widget.controller.valueBackGroundgColor),
            ),
            children: List.generate(
              data.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  left: widget.controller.valuePadding?.left?.toDouble() ?? 0,
                  right: widget.controller.valuePadding?.right?.toDouble() ?? 0,
                  top: widget.controller.valuePadding?.top?.toDouble() ?? 0,
                  bottom:
                      widget.controller.valuePadding?.bottom?.toDouble() ?? 0,
                ),
                child: Center(
                  child: Text(
                    data[index],
                    style: TextStyle(
                      fontSize: widget.controller.valueFontSize?.toDouble(),
                      fontWeight: stringToFontWeight(
                              widget.controller.valueFontWeight) ??
                          FontWeight.normal,
                      color: hexToColor(widget.controller.valueTextColor),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
