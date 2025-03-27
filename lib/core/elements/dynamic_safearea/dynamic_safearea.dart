import 'package:flutter/material.dart';
import 'package:hana_sdk/core/elements/dynamic_safearea/dynamic_safearea_model.dart';

class DynamicSafearea extends StatelessWidget {
  final DynamicSafeareaModel controller;
  final Widget? formWidgets;

  const DynamicSafearea({
    super.key,
    required this.controller,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: controller.bottom ?? true,
      left: controller.left ?? true,
      right: controller.right ?? true,
      top: controller.top ?? true,
      maintainBottomViewPadding: controller.maintainBottomViewPadding ?? false,
      minimum: EdgeInsets.only(
          left: controller.minimum?.left?.toDouble() ?? 0,
          right: controller.minimum?.right?.toDouble() ?? 0,
          top: controller.minimum?.top?.toDouble() ?? 0,
          bottom: controller.minimum?.bottom?.toDouble() ?? 0),
      child: formWidgets ?? SizedBox.shrink(),
    );
  }
}
