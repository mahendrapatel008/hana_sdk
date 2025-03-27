import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_positioned/dynamic_positioned_model.dart';

class DynamicPositioned extends StatelessWidget {
  final DynamicPositionedModel model;
  final Widget? formWidgets;
  final FormController formController;

  const DynamicPositioned({
    super.key,
    required this.model,
    required this.formWidgets,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: model.top,
      left: model.left,
      right: model.right,
      bottom: model.bottom,
      width: model.width,
      height: model.height,
      child: formWidgets ?? SizedBox.shrink(),
    );
  }
}
