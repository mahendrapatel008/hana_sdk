import 'package:flutter/material.dart';
import 'package:hana_sdk/core/elements/dynamic_sizedbox/dynamic_sizedbox_model.dart';

class DynamicSizedbox extends StatelessWidget {
  final DynamicSizedBoxModel model;
  final Widget formWidgets;
  const DynamicSizedbox(
      {super.key, required this.model, required this.formWidgets});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: model.height?.toDouble(),
      width: model.width?.toDouble(),
      child: formWidgets,
    );
  }
}
