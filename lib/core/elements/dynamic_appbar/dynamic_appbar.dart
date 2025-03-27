import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar_model.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_model.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_model.dart';
import 'package:hana_sdk/core/utils/device_utility.dart';

class DynamicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final DynamicAppbarModel controller;
  final List<Widget> formWidgets;
  final VoidCallback onPressed;
  final FormController formController;

  const DynamicAppbar({
    super.key,
    required this.controller,
    required this.formWidgets,
    required this.onPressed,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return controller.backImgUrl != null
        ? AppBar(
            actions: formWidgets,
            leading: controller.backImgUrl != null
                ? DynamicImage(
                    formController: formController,
                    controller: controller.backImgUrl ?? DynamicImageModel(),
                    onPressed: onPressed)
                : Container(),
            automaticallyImplyLeading: false,
            title: DynamicText(
              controller: controller.title ??
                  DynamicTextModel(label: 'Home', type: 'text'),
              formController: formController,
            ),
          )
        : AppBar(
            actions: formWidgets,
            automaticallyImplyLeading: false,
            title: DynamicText(
              controller: controller.title ??
                  DynamicTextModel(label: 'Home', type: 'text'),
              formController: formController,
            ),
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
