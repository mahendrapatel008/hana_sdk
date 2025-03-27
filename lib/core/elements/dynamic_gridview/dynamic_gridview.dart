import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_gridview/dynamic_gridview_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicGridView extends StatefulWidget {
  final DynamicGridViewModel controller;
  final FormController formController;

  const DynamicGridView({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicGridView> createState() => _DynamicGridViewState();
}

class _DynamicGridViewState extends State<DynamicGridView> {
  Axis scrollDirection = Axis.vertical;
  List<dynamic>? itemsData = [];
  @override
  void initState() {
    super.initState();
  }

  void _initState() {
    var dynamicData;
    if ((widget.controller.dataKey != null &&
        widget.controller.dataKey!.isNotEmpty)) {
      dynamicData = resolveDynamicValue(widget.controller.dataKey,
          widget.controller.item.toString(), widget.formController);

      if (dynamicData != null) {
        itemsData = dynamicData as List<dynamic>;
      }
      // if (dynamicData is Map<String, dynamic>) {
      //   itemsData = DynamicListModel.fromJson(dynamicData).items;
      // }
      // else if (dynamicData is List) {
      //   itemsData =
      //       dynamicData.map((item) => ChartData.fromJson(item)).toList();
      // }
      else {
        itemsData = widget.controller.items;
      }
    } else {
      // Use items directly from the controller if no dynamic data
      itemsData = widget.controller.items;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initState();
    // var items = widget.controller.items;
    // for (var element in items) {
    //   element.forEach((key, value) {
    //     widget.formController.saveDynamicValue(key, value);
    //   });
    // }

    return GridView.builder(
      scrollDirection: scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: widget.controller.childHeight?.toDouble() ?? 100,

        crossAxisCount:
            widget.controller.crossAxisCount ?? 2, // Number of columns
        crossAxisSpacing: widget.controller.crossAxisSpacing?.toDouble() ??
            10, // Space between columns
        mainAxisSpacing: widget.controller.mainAxisSpacing?.toDouble() ??
            10, // Space between rows
      ),
      itemCount: itemsData!.length,
      shrinkWrap: true,
      physics: scrollDirection == Axis.vertical
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var field = widget.controller.item;
        Widget? formWidgets;
        if (field != null && field != []) {
          var formElement = ApiFormElements.fromJson({
            "type": field['type'],
            "items": field,
          });
          formElement.formController = widget.formController;
          itemsData![index].forEach((key, value) {
            print('Key:???? $key, Value: $value');
            saveDynamicValue(key, value);
          });
          var apiElementController =
              ApiElementController(formSectionsElements: formElement);
          formWidgets = apiElementController.buildFormElement();
        }
        return Container(child: formWidgets);
      },
    );
  }
}
