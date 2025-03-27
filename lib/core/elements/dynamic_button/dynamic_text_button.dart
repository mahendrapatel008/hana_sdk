import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button_model.dart';

class DynamicTextButton extends StatelessWidget {
  final DynamicButtonModel controller;
  final VoidCallback? onPressed;
  final FormController formController;

  const DynamicTextButton({
    super.key,
    required this.controller,
    required this.formController,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: (0)),
      child: TextButton(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: controller.onClickData != null ? onPressed : null,
        child: Text(
          controller.label ?? '',
          style: TextStyle(
            fontSize: controller.fontSize?.toDouble() ?? 12,
            fontWeight: FontWeight.bold,
            color: controller.titleColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
