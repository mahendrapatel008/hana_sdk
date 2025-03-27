import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_spacer/dynamic_spacer_model.dart';

class DynamicSpacer extends StatelessWidget {
  final DynamicSpacerModel model;
  final FormController formController;
  const DynamicSpacer({
    super.key,
    required this.model,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return Spacer(
      flex: model.flex ?? 1,
    );
  }
}
