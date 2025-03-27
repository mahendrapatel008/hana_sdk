import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/elements/dynamic_row/dynamic_row_model.dart';

class DynamicRow extends StatelessWidget {
  final List<Widget> formWidgets;
  final DynamicRowModel model;

  const DynamicRow({
    super.key,
    required this.formWidgets,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    if (model.scrollable == true) {
      return SingleChildScrollView(
        scrollDirection: stringToAxis('horizontal') ?? Axis.horizontal,
        child: Row(
          mainAxisAlignment:
              stringMainAxis(model.mainAxis) ?? MainAxisAlignment.start,
          crossAxisAlignment:
              stringCrossAxis(model.crossAxis) ?? CrossAxisAlignment.start,
          children: formWidgets,
        ),
      );
    } else {
      return Row(
        mainAxisAlignment:
            stringMainAxis(model.mainAxis) ?? MainAxisAlignment.start,
        crossAxisAlignment:
            stringCrossAxis(model.crossAxis) ?? CrossAxisAlignment.start,
        children: formWidgets,
      );
    }
  }
}
