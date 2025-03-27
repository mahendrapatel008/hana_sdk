import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/elements/dynamic_scrollview/dynamic_scrollview_model.dart';

class DynamicScrollview extends StatelessWidget {
  final DynamicScrollViewModel model;
  final Widget? formWidgets;
  const DynamicScrollview({
    super.key,
    required this.model,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: stringToAxis(model.scrollDirection) ?? Axis.vertical,
        child: formWidgets);
  }
}
