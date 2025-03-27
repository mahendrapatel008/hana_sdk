import 'package:flutter/material.dart';

class CheckboxElement extends StatefulWidget {
  final String label;
  final Function(bool) onChanged;

  const CheckboxElement({super.key, required this.label, required this.onChanged});

  @override
  _CheckboxElementState createState() => _CheckboxElementState();
}

class _CheckboxElementState extends State<CheckboxElement> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.label),
      value: _isChecked,
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            _isChecked = value;
          });
          widget.onChanged(value);
        }
      },
    );
  }
}
