import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button_model.dart';

class DynamicButton extends StatelessWidget {
  final DynamicButtonModel controller;
  final VoidCallback? onPressed;
  final FormController formController;
  const DynamicButton({
    super.key,
    required this.controller,
    required this.formController,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: controller.height?.toDouble() ?? 48,
      width: controller.width?.toDouble() ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(7),
        ),
        color: controller.color,
      ),
      child: ElevatedButton(
        onPressed: controller.onClickData != null ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          controller.label ?? '',
          style: TextStyle(
            fontSize: controller.fontSize?.toDouble() ?? 12,
            fontWeight: FontWeight.w600,
            color: controller.titleColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
