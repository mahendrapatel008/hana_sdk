import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar_model.dart';

class DynamicAppbarController extends StatefulWidget {
  final DynamicAppbarModel controller;
  final FormController formController;
  const DynamicAppbarController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicAppbarController> createState() =>
      _DynamicAppbarControllerState();
}

class _DynamicAppbarControllerState extends State<DynamicAppbarController> {
  @override
  void initState() {
    widget.formController.saveFieldName(widget.controller.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgets = [];
    if (widget.controller.items != null) {
      var fields = widget.controller.items;
      for (var field in fields ?? []) {
        var formElement = ApiFormElements.fromJson({
          "type": field['type'],
          "items": field,
        });
        formElement.formController = widget.formController;
        var apiElementController =
            ApiElementController(formSectionsElements: formElement);
        formWidgets.add(apiElementController.buildFormElement());
      }
    }
    return DynamicAppbar(
      controller: widget.controller,
      formWidgets: formWidgets,
      formController: widget.formController,
      onPressed: () {
        if (widget.controller.backImgUrl?.onClickData?.isBack ?? true) {
          context.pop();
        } else {
          var pageName = widget.controller.backImgUrl?.onClickData?.pageName;
          if (pageName != null && pageName.isNotEmpty) {
            context.push(
              '/dynamic_form',
              extra: {'token': '1', 'pageName': pageName},
            );
          }
        }
      },
    );
  }
}
