import 'package:flutter/material.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/elements/dynamic_column/dynamic_column_model.dart';

class DynamicColumn extends StatelessWidget {
  final DynamicColumnModel model;
  final List<Widget> formWidgets;
  const DynamicColumn({
    super.key,
    required this.model,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    if (model.scrollable == true) {
      return SingleChildScrollView(
        scrollDirection: stringToAxis('vertical') ?? Axis.vertical,
        child: Column(
          mainAxisAlignment:
              stringMainAxis(model.mainAxis) ?? MainAxisAlignment.start,
          crossAxisAlignment:
              stringCrossAxis(model.crossAxis) ?? CrossAxisAlignment.start,
          children: formWidgets,
        ),
      );
    } else {
      return Column(
        mainAxisAlignment:
            stringMainAxis(model.mainAxis) ?? MainAxisAlignment.start,
        crossAxisAlignment:
            stringCrossAxis(model.crossAxis) ?? CrossAxisAlignment.start,
        children: formWidgets,
      );
    }
  }
}
