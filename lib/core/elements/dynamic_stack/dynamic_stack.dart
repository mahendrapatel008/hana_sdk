import 'package:flutter/material.dart';
import 'package:hana_sdk/core/elements/dynamic_stack/dynamic_stack_model.dart';

class DynamicStack extends StatelessWidget {
  final DynamicStackModel model;
  final List<Widget> formWidgets;

  const DynamicStack({
    super.key,
    required this.model,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: model.alignment ?? Alignment.center,
      textDirection: model.textDirection ?? TextDirection.ltr,
      fit: model.stackFit ?? StackFit.loose,
      clipBehavior: model.clipBehavior ?? Clip.none,
      children: formWidgets,
    );
  }
}
