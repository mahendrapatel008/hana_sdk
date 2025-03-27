import 'package:flutter/material.dart';

class DropdownElement extends StatelessWidget {
  final String label;
  final List<Map<String, dynamic>> items;
  final Function(String) onChanged;

  const DropdownElement({super.key, required this.label, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(item['label']),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
