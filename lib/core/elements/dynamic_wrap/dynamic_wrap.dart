import 'package:flutter/material.dart';
import 'package:hana_sdk/core/elements/dynamic_wrap/dynamic_wrap_model.dart';

class DynamicWrap extends StatelessWidget {
  final DynamicWrapModel model;
  final List<Widget> formWidgets;

  const DynamicWrap({
    super.key,
    required this.model,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: model.direction ?? Axis.horizontal,
      alignment: model.alignment ?? WrapAlignment.start,
      clipBehavior: model.clipBehavior ?? Clip.none,
      crossAxisAlignment: model.crossAxisAlignment ?? WrapCrossAlignment.start,
      runAlignment: model.runAlignment ?? WrapAlignment.start,
      runSpacing: model.runSpacing ?? 0.0,
      spacing: model.spacing ?? 0.0,
      textDirection: model.textDirection,
      verticalDirection: model.verticalDirection ?? VerticalDirection.down,
      children: formWidgets,
    );
  }
}
