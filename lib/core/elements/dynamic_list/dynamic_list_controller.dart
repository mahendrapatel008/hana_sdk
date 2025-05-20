import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/controllers/onclickdata_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_list/dynamic_list_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicListController extends StatefulWidget {
  final DynamicListModel controller;
  final FormController formController;

  const DynamicListController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicListController> createState() => _DynamicListControllerState();
}

class _DynamicListControllerState extends State<DynamicListController> {
  List<dynamic>? itemsData;
  String locationResult = '';
  bool isItemClicked = false; // Flag to track if item is clicked
  Map<String, dynamic> mergedData = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initLoad(DynamicListModel displayController) async {
    if (isItemClicked) {
      // Skip loading data when an item is clicked
      return;
    }

    dynamic dynamicData;

    if (displayController.dataKey != null &&
        displayController.dataKey!.isNotEmpty) {
      dynamicData = await resolveDynamicValue(
        displayController.dataKey,
        displayController.item.toString(),
        widget.formController,
      );
      if (dynamicData.isNotEmpty) {
        if (dynamicData is List) {
          itemsData = dynamicData;
        } else {
          final parsedData = jsonDecode(dynamicData);
          if (parsedData is List) {
            itemsData =
                parsedData.cast<Map<String, dynamic>>(); // Ensure correct type
          } else {
            log("Parsed data is not a List: $parsedData");
            itemsData = [];
          }
        }
      } else {
        itemsData = displayController.item ?? [];
      }
    } else {
      itemsData = displayController.item ?? [];
    }
    universalListData = convertToListOfMaps(itemsData);
    print("Parsed Items Data as List<dynamic>: $itemsData");
  }

  List<Map<String, dynamic>>? convertToListOfMaps(List<dynamic>? inputList) {
    if (inputList == null) return null; // Return null if input is null

    return inputList.map((item) {
      if (item is Map<String, dynamic>) {
        return item; // If already a Map<String, dynamic>, return as-is
      } else if (item is String) {
        try {
          return jsonDecode(item) as Map<String, dynamic>; // Decode string JSON
        } catch (e) {
          print("Error decoding JSON string: $e");
          return <String, dynamic>{}; // Return empty map in case of error
        }
      } else {
        return <String, dynamic>{}; // Return empty map if conversion fails
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool containsAllPrerequisites = false;
    if (widget.formController.dynamicData
        .containsKey("dependentInvisibleFields")) {
      try {
        // Directly pass the Map if it's already a parsed JSON object
        final dependentInvisibleFields = DependentInvisibleFields.fromJson(
          widget.formController.dynamicData["dependentInvisibleFields"],
        );
        // Check if any of the dependentInvisibleFields contains the name
        containsAllPrerequisites = dependentInvisibleFields.fieldNames
            .contains(widget.controller.name);
      } catch (e) {
        print("Error parsing dependentInvisibleFields: $e");
      }
    }
    if (widget.controller.isHideAndShow ?? false) {
      containsAllPrerequisites = widget.controller.prerequisite != null &&
          widget.controller.prerequisite!.every((prerequisite) => widget
              .formController.savePrerequisitesNameData
              .contains(prerequisite.name));
    }
    DynamicListModel? containsAllPrerequisitesDesign;
    // Handle hanaPrerequisiteDesign if no prerequisites matched
    if (!containsAllPrerequisites) {
      if (widget.controller.hanaPrerequisiteDesign != null &&
          widget.controller.hanaPrerequisiteDesign!.isNotEmpty) {
        final matchingPrerequisites = widget
            .formController.savePrerequisitesNameData
            .where((name) => widget.controller.hanaPrerequisiteDesign!
                .any((prerequisite) => prerequisite.name == name))
            .map((name) => widget.controller.hanaPrerequisiteDesign!
                .firstWhere((prerequisite) => prerequisite.name == name))
            .toList();

        // Check if any matching prerequisites should remove others
        for (var prerequisite in matchingPrerequisites) {
          if (prerequisite.isOtherRemove == true) {
            widget.formController.savePrerequisitesNameData
                .where((name) =>
                    name != prerequisite.name &&
                    widget.controller.hanaPrerequisiteDesign!.any(
                        (otherPrerequisite) => otherPrerequisite.name == name))
                .toList()
                .forEach((name) => widget.formController
                    .removePrerequisitesName(context, name as String?));

            final remainingPrerequisites = widget
                .controller.hanaPrerequisiteDesign!
                .where((prerequisite) => widget
                    .formController.savePrerequisitesNameData
                    .contains(prerequisite.name))
                .toList();

            if (remainingPrerequisites.isNotEmpty) {
              var style = remainingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicListModel.fromJson(style);
              } else if (style is DynamicListModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicListModel.fromJson(style);
              } else if (style is DynamicListModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicListModel(
      type: containsAllPrerequisitesDesign?.type ?? widget.controller.type,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      height:
          containsAllPrerequisitesDesign?.height ?? widget.controller.height,
      item: containsAllPrerequisitesDesign?.item ?? widget.controller.item,
      items: containsAllPrerequisitesDesign?.items ?? widget.controller.items,
      scrollDirection: containsAllPrerequisitesDesign?.scrollDirection ??
          widget.controller.scrollDirection,
      onClickData: containsAllPrerequisitesDesign?.onClickData ??
          widget.controller.onClickData,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
    );
    return FutureBuilder<void>(
        future: _initLoad(displayController),
        builder: (context, snapshot) {
          log("This has been called");
          return !containsAllPrerequisites &&
                  (itemsData != null && itemsData!.isNotEmpty)
              ? SizedBox(
                  height: widget.controller.scrollDirection == Axis.vertical
                      ? null
                      : widget.controller.height?.toDouble(),
                  child: ListView.builder(
                      scrollDirection:
                          displayController.scrollDirection ?? Axis.vertical,
                      itemCount: itemsData?.length,
                      shrinkWrap: true,
                      physics:
                          displayController.scrollDirection == Axis.vertical
                              ? const NeverScrollableScrollPhysics()
                              : const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // var field = displayController.item;
                        // var formElement = ApiFormElements.fromJson({
                        //   "type": field['type'],
                        //   "items": field,
                        // });
                        // Widget formWidgets;
                        // var apiElementController =
                        //     ApiElementController(formSectionsElements: formElement);
                        // formWidgets = apiElementController.buildFormElement();
                        itemsData?[index].forEach((key, value) {
                          print('Key:???? $key, Value: $value');
                          saveDynamicValue(key, value);
                        });
                        saveDynamicValue('index', index);
                        var field = displayController.items;
                        Widget? formWidgets;
                        if (field != null && field != []) {
                          var formElement = ApiFormElements.fromJson({
                            "type": field['type'],
                            "items": field,
                          });
                          formElement.formController = widget.formController;

                          var apiElementController = ApiElementController(
                              formSectionsElements: formElement);
                          formWidgets = apiElementController.buildFormElement();
                        }
                        return displayController.onClickData != null
                            ? GestureDetector(
                                onTap: displayController.onClickData != null
                                    ? () {
                                        setState(() {
                                          isItemClicked = true;
                                        });
                                        if (itemsData?[index] != null &&
                                            itemsData![index]!
                                                .toString()
                                                .isNotEmpty) {
                                          hanaVar1 = itemsData?[index];
                                        }
                                        handleDynamicOnClick(
                                            displayController, mergedData);
                                        // context.push(
                                        //   '/dynamic_form',
                                        //   extra: {
                                        //     'token': '1',
                                        //     'pageName': widget.controller
                                        //         .onClickData?.pageName,
                                        //     'listData': itemsData?[index],
                                        //     'isFromList': true,
                                        //   },
                                        // );
                                        // Reset flag after the onClickData logic has executed
                                      }
                                    : () {},
                                child: formWidgets,
                              )
                            : formWidgets;
                      }),
                )
              : SizedBox.shrink();
        });
  }

  Future<void> handleDynamicOnClick(
      DynamicListModel controller, Map<String, dynamic> mergedData) async {
    final onClickHandler = DynamicOnClickHandler(
      onClickData: controller.onClickData,
      formController: widget.formController,
      dName: controller.name,
      mergedData: mergedData,
      context: context,
      hanaPrerequisiteDesign: controller.hanaPrerequisiteDesign,
      locationResult: locationResult,
    );

    await onClickHandler.handleDynamicClick();
  }
}
