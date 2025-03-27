import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_timepicker/dynamic_timepicker_model.dart';

class DynamicTimePicker extends StatefulWidget {
  final DynamicTimePickerModel controller;
  final FormController formController;

  const DynamicTimePicker({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTimePicker> createState() => _DynamicTimePickerState();
}

class _DynamicTimePickerState extends State<DynamicTimePicker> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.controller.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        selectedTime != null ? selectedTime!.format(context) : 'Select Time',
        style: TextStyle(color: widget.controller.textColor),
      ),
      trailing: Icon(Icons.access_time, color: widget.controller.textColor),
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime:
              selectedTime ?? widget.controller.initialTime ?? TimeOfDay.now(),
        );
        if (picked != null && picked != selectedTime) {
          setState(() {
            selectedTime = picked;
            widget.formController.saveFieldValue(
              widget.controller.name ?? '',
              selectedTime!.format(context),
            );
          });
        }
      },
    );
  }
}
