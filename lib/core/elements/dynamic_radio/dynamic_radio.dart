import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_radio/dynamic_radio_model.dart';

class DynamicRadio extends StatefulWidget {
  final DynamicRadioModel controller;
  final FormController formController;

  const DynamicRadio({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicRadio> createState() => _DynamicRadioState();
}

class _DynamicRadioState extends State<DynamicRadio> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize selectedValue, if you need a default value set it here
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.controller.items!.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: widget.controller.backGroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(
                widget.controller.radius?.toDouble() ?? 8.0),
            border: Border.all(
              color: widget.controller.borderColor ?? Colors.grey,
              width: widget.controller.borderWidth?.toDouble() ?? 1.0,
            ),
          ),
          child: RadioListTile<String>(
            value: item,
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                widget.formController.saveFieldValue(
                    widget.controller.name ?? '', selectedValue ?? '');
              });
            },
            title: Text(
              item,
              style: TextStyle(
                color: widget.controller.textColor,
                fontSize: widget.controller.textSize?.toDouble() ?? 14,
                fontWeight: widget.controller.textWeight,
              ),
            ),
            activeColor: widget.controller.radioActiveColor,
          ),
        );
      }).toList(),
    );
  }
}
