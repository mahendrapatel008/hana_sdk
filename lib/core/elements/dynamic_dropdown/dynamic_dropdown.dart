import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_event.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_dropdown/dynamic_dropdown_model.dart';
import 'package:hana_sdk/core/model/common_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicDropdown extends StatefulWidget {
  final DynamicDropdownModel controller;
  final FormController formController;
  final VoidCallback? onPressed;
  final AutovalidateMode autovalidateMode;

  const DynamicDropdown({
    super.key,
    required this.controller,
    required this.formController,
    required this.onPressed,
    this.autovalidateMode = AutovalidateMode.always,
  });

  @override
  State<DynamicDropdown> createState() => _DynamicDropdownState();
}

class _DynamicDropdownState extends State<DynamicDropdown> {
  String? selection;
  List<CommonModel> dynamicItems = [];
  List<CommonModel> itemData = [];
  String? cachedResolvedText;

  @override
  void initState() {
    super.initState();
    initialSelection();
    preloadDynamicData();
  }

  Future<void> initialSelection() async {
    selection = await resolveDynamicValue(
        widget.controller.id, widget.controller.label, widget.formController);
    if (selection != null) {
      widget.formController
          .saveFieldValue(widget.controller.name.toString(), selection);
      widget.formController.setdynamicElementsKeyValues(
        widget.controller.name ?? '',
        selection ?? '',
      );
    }
  }

  Future<void> preloadDynamicData() async {
    final resolvedText = await resolveDynamicValue(
      widget.controller.dataKey,
      widget.controller.label,
      widget.formController,
    );

    if (mounted) {
      setState(() {
        cachedResolvedText = resolvedText;
        _processDynamicItems(resolvedText);
      });
    }
  }

  void _processDynamicItems(String resolvedText) {
    try {
      print("Resolved Text Before Formatting: $resolvedText");

      if (resolvedText.trim().isEmpty) {
        print("Resolved text is empty, skipping JSON parsing.");
        dynamicItems = widget.controller.items ?? [];
        return;
      }

      final formattedData = resolvedText
          .replaceAllMapped(
        RegExp(r'([{\[,])\s*([a-zA-Z_][a-zA-Z0-9_]*):'),
        (match) => '${match.group(1)}"${match.group(2)}":',
      )
          .replaceAllMapped(
        RegExp(r':\s*([^,"\]}]+)([,}\]])'),
        (match) {
          final value = match.group(1)!;
          if (RegExp(r'^\d+$').hasMatch(value)) {
            return ': $value${match.group(2)}';
          } else {
            return ': "$value"${match.group(2)}';
          }
        },
      );

      print("Formatted Data: $formattedData");

      // Validate JSON before decoding
      if (!formattedData.startsWith("{") && !formattedData.startsWith("[")) {
        throw FormatException(
            "Invalid JSON format: Does not start with '{' or '['");
      }

      final dynamic decodedText = jsonDecode(formattedData);

      if (decodedText is Map<String, dynamic>) {
        dynamicItems = DynamicDropdownModel.fromJson(decodedText).items ?? [];
      } else if (decodedText is List) {
        dynamicItems =
            decodedText.map((item) => CommonModel.fromJson(item)).toList();
      } else {
        dynamicItems = widget.controller.items ?? [];
      }

      dynamicItems = dynamicItems.toSet().toList();
    } catch (e) {
      print("Error decoding resolvedText: $e");
      dynamicItems = widget.controller.items ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: resolveDynamicValue(
        widget.controller.dataKey,
        widget.controller.label,
        widget.formController,
      ),
      builder: (context, snapshot) {
        final resolvedText = snapshot.data ?? widget.controller.label ?? '...';

        if (cachedResolvedText != resolvedText) {
          cachedResolvedText = resolvedText;
          _processDynamicItems(resolvedText);
        }

        return buildDropdown();
      },
    );
  }

  Widget buildDropdown() {
    return DropdownButtonFormField<String>(
      autovalidateMode: widget.autovalidateMode,
      value: dynamicItems.any((item) => item.name == selection)
          ? selection
          : dynamicItems.any((item) => item.id == selection)
              ? selection
              : null, // Ensures no invalid selections
      items: dynamicItems
          .map(
            (item) => DropdownMenuItem<String>(
              value: item.name,
              child: Text(
                item.name.toString(),
                style: TextStyle(
                  color: widget.controller.textColor,
                  fontSize: widget.controller.textSize?.toDouble() ?? 14,
                  fontWeight: widget.controller.textWeight,
                ),
              ),
            ),
          )
          .toList(),
      validator: widget.controller.required == true
          ? (String? value) {
              String? errorMessage;
              if (value == null || value.isEmpty) {
                errorMessage =
                    widget.controller.validator ?? 'This field is required';
              }
              widget.formController.setValidationState(
                widget.controller.isId == true
                    ? widget.controller.id ?? ''
                    : widget.controller.name ?? '',
                errorMessage,
              );
              return errorMessage;
            }
          : null,
      onChanged: widget.controller.readOnly == true
          ? null
          : (value) {
              setState(() {
                selection = value;

                // Save field value
                for (var item in dynamicItems) {
                  if (item.name == selection) {
                    widget.formController.saveFieldValue(
                      widget.controller.name.toString(),
                      widget.controller.isId == true
                          ? item.id.toString()
                          : item.name.toString(),
                    );
                    widget.formController.setdynamicElementsKeyValues(
                      widget.controller.name ?? '',
                      item.id ?? '',
                    );
                    break;
                  }
                }

                if (widget.onPressed != null) {
                  widget.onPressed!.call();
                }
              });

              // Trigger refresh for dependent fields
              BlocProvider.of<RefreshBloc>(context).add(
                RefreshFormEvent(check: widget.controller.name.toString()),
              );
            },
      hint: Text(
        selection ?? widget.controller.placeholder ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.controller.textColor,
        ),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.controller.backGroundColor,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(widget.controller.radius?.toDouble() ?? 0),
          borderSide: BorderSide(
            color: widget.controller.borderColor ?? Colors.black,
            width: widget.controller.borderWidth?.toDouble() ?? 1.0,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      ),
      dropdownColor: widget.controller.backGroundColor,
    );
  }
}
