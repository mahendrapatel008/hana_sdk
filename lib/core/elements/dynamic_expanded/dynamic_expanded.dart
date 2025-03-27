import 'package:flutter/material.dart';
import 'package:hana_sdk/core/elements/dynamic_expanded/dynamic_expanded_model.dart';

class DynamicExpanded extends StatelessWidget {
  final DynamicExpandedModel model;
  final Widget? formWidgets;

  const DynamicExpanded({
    super.key,
    required this.model,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: model.flex ?? 1,
      child: formWidgets ?? SizedBox.shrink(),
    );
  }
}
