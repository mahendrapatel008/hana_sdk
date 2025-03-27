import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicRepaintBoundary extends StatefulWidget {
  final FormController formController;
  final Widget? formWidgets;

  const DynamicRepaintBoundary({
    super.key,
    required this.formController,
    required this.formWidgets,
  });

  @override
  State<DynamicRepaintBoundary> createState() => _DynamicRepaintBoundaryState();
}

class _DynamicRepaintBoundaryState extends State<DynamicRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKeyProvider.repaintBoundaryKey, // Use the singleton key here,
      child: widget.formWidgets,
    );
  }
}
