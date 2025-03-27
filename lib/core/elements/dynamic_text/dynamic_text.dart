import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_model.dart';
import 'package:hana_sdk/core/services/font_services.dart';
import 'package:hana_sdk/core/services/location_fetcher.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:intl/intl.dart';

class DynamicText extends StatefulWidget {
  final DynamicTextModel controller;
  final FormController formController;

  const DynamicText({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicText> createState() => _DynamicTextState();
}

class _DynamicTextState extends State<DynamicText> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> _fetchLocation() async {
    await fetchCurrentLocation(
        widget.controller.addressFormate ?? "{name} {locality}, {country}");
    return (widget.controller.locationFormate ??
            "{latitude} {longitude} {locationAddress}")
        .replaceAll("{latitude}", SharedPrefs().latitude.toString())
        .replaceAll("{longitude}", SharedPrefs().longitude.toString())
        .replaceAll(
            "{locationAddress}", SharedPrefs().locationAddress.toString());
  }

  String _generateCurrentTime() {
    final now = DateTime.now();
    final timeFormatter =
        DateFormat('h:mm a'); // 'h' is for 12-hour format, 'a' is for AM/PM
    return timeFormatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.controller.showTime == true
          ? Future.value(_generateCurrentTime())
          : widget.controller.showLocation == true
              ? _fetchLocation()
              : resolveDynamicValue(widget.controller.dataKey,
                  widget.controller.label, widget.formController),
      builder: (context, snapshot) {
        final resolvedText = snapshot.data ?? widget.controller.label ?? '...';

        return Text(
          resolvedText,
          softWrap: widget.controller.softWrap,
          textAlign: stringToTextAlign(widget.controller.textAlign ?? 'start'),
          maxLines: widget.controller.maxLines ?? 1,
          overflow: widget.controller.overflow,
          style: FontService.custom(
            fontSize: widget.controller.fontSize?.toDouble() ?? 14.0,
            fontWeight: stringToFontWeight(widget.controller.fontWeight) ??
                FontWeight.normal,
            color: hexToColor(widget.controller.textColor) ?? Colors.black,
          ),
        );
      },
    );
  }
}
