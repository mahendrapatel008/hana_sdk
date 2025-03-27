import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_checkbox/dynamic_checkbox_model.dart';

class DynamicCheckBox extends StatefulWidget {
  final DynamicCheckBoxModel controller;
  final FormController formController;
  final AutovalidateMode autovalidateMode; // Add this new field

  const DynamicCheckBox(
      {super.key,
      required this.controller,
      required this.formController,
      this.autovalidateMode = AutovalidateMode.onUserInteraction});

  @override
  State<DynamicCheckBox> createState() => _DynamicCheckBoxState();
}

class _DynamicCheckBoxState extends State<DynamicCheckBox> {
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // No default selection - start with an empty selectedItems list
    // selectedItems = []; already initialized
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
            color: widget.controller.backGroundColor ??
                Colors.transparent, // Dynamically set the background color
            borderRadius: BorderRadius.circular(
                widget.controller.radius?.toDouble() ?? 8.0),
            border: Border.all(
              color: widget.controller.borderColor ?? Colors.grey,
              width: widget.controller.borderWidth?.toDouble() ?? 1.0,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: widget.controller.checkboxColor ??
                  Colors.black, // Checkbox border color
            ),
            child: CheckboxListTile(
              value: selectedItems.contains(item),
              title: Text(
                item,
                style: TextStyle(
                  fontSize: widget.controller.textSize?.toDouble() ?? 14.0,
                  fontWeight: widget.controller.textWeight ?? FontWeight.normal,
                  color: widget.controller.textColor ?? Colors.black,
                ),
              ),
              activeColor:
                  widget.controller.checkboxColor, // Checkbox fill color
              checkColor:
                  widget.controller.checkTickColor, // Checkbox tick color
              onChanged: (bool? isChecked) {
                widget.formController
                    .savePrerequisitesName(context, widget.controller.name);
                setState(() {
                  if (isChecked == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                  // Save the selected items as a comma-separated string
                  widget.formController.saveFieldValue(
                    widget.controller.name ?? '',
                    selectedItems.join(','),
                  );
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        );
      }).toList(),
    );
  }
}
