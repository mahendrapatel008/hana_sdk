import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_Inkwell/dynamic_Inkwell_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicInkWell extends StatelessWidget {
  final DynamicInkWellModel model;
  final Widget formWidgets;
  final Function(OnClickData? onClickData)? onPressed;
  final FormController formController;

  const DynamicInkWell({
    super.key,
    required this.model,
    required this.formWidgets,
    this.onPressed,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    int? index = saveDynamicData['index'];
    return InkWell(
      onTap: () {
        universalIndex = index;
        if (model.onTap != null) {
          onPressed!(model.onTap);
        }
      },
      onDoubleTap: () {
        if (model.onDoubleTap != null) {
          onPressed!(model.onDoubleTap);
        }
      },
      onHover: (value) {
        if (model.onHover != null) {
          if (value) {
            onPressed!(model.onHover);
          }
        }
      },
      onLongPress: () {
        if (model.onLongPress != null) {
          onPressed!(model.onLongPress);
        }
      },
      // mouseCursor: MouseCursor.uncontrolled,
      autofocus: true,
      enableFeedback: true,
      hoverColor: model.hoverColor,
      focusColor: model.focusColor,
      highlightColor: model.highlightColor,
      splashColor: model.splashColor,
      hoverDuration: model.hoverDuration,
      child: formWidgets,
    );
  }
}
