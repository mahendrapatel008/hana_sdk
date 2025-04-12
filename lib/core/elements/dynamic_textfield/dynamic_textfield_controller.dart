import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_textfield/dynamic_textfield.dart';
import 'package:hana_sdk/core/elements/dynamic_textfield/dynamic_textfield_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicTextFieldController extends StatefulWidget {
  final DynamicTextFieldModel controller;
  final FormController formController;

  const DynamicTextFieldController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTextFieldController> createState() =>
      _DynamicTextFieldControllerState();
}

class _DynamicTextFieldControllerState extends State<DynamicTextFieldController>
    with ChangeNotifier {
  bool isPassVisible = false;
  bool isobscureText = false;
  TextEditingController constText = TextEditingController();
  String? errorMessage; // Store validation error message

  @override
  void initState() {
    dynamicData();
    super.initState();
  }

  Future<void> dynamicData() async {
    widget.formController.saveFieldName(widget.controller.name);

    if (widget.formController.formData.containsKey(widget.controller.name)) {
      constText.text = widget.formController.formData[widget.controller.name];
    } else {
      constText.text = await resolveDynamicValue(
          widget.controller.id, widget.controller.label, widget.formController);
      if (constText.text.isNotEmpty) {
        widget.formController
            .saveFieldValue(widget.controller.name ?? '', constText.text);
      }
    }

    isobscureText = widget.controller.obscureText ?? false;
    isPassVisible = widget.controller.obscureText ?? false;

    if (widget.controller.required == true && (constText.text.isEmpty)) {
      print("cnhsbfdsdbhbhs");
      widget.formController.setValidationState(widget.controller.name ?? '',
          widget.controller.validator ?? 'This field is required');
    }
  }

  void _validate(String? value, DynamicTextFieldModel displayController) {
    print('cnhsbfdsdbhbhAAA$value');
    if (displayController.required == true) {
      if (displayController.regex != null &&
          displayController.regex!.isNotEmpty) {
        final RegExp regexPattern = RegExp(displayController.regex!);
        if (value == null || value.isEmpty) {
          errorMessage = "This field is required";
        } else if (!regexPattern.hasMatch(value)) {
          errorMessage = displayController.regexError ??
              "Invalid format"; // Customize this error message
        } else {
          errorMessage = null;
        }
      } else {
        if (value == null || value.isEmpty) {
          print("cnhsbfdsdbhbhBBB");
          errorMessage =
              displayController.validator ?? 'This field is required';
        } else {
          errorMessage = null;
        }
      }
      if (errorMessage != null) {
        print("cnhsbfdsdbhbhssss");
        widget.formController
            .setValidationState(displayController.name ?? '', errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool containsAllPrerequisites = false;
    if (widget.formController.dynamicData
        .containsKey("dependentInvisibleFields")) {
      try {
        final dependentInvisibleFields = DependentInvisibleFields.fromJson(
          widget.formController.dynamicData["dependentInvisibleFields"],
        );
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
    DynamicTextFieldModel? containsAllPrerequisitesDesign;
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
                    DynamicTextFieldModel.fromJson(style);
              } else if (style is DynamicTextFieldModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicTextFieldModel.fromJson(style);
              } else if (style is DynamicTextFieldModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicTextFieldModel(
      label: containsAllPrerequisitesDesign?.label ?? widget.controller.label,
      id: containsAllPrerequisitesDesign?.id ?? widget.controller.id,
      name: containsAllPrerequisitesDesign?.name ?? widget.controller.name,
      required: containsAllPrerequisitesDesign?.required ??
          widget.controller.required,
      maxLength: containsAllPrerequisitesDesign?.maxLength ??
          widget.controller.maxLength,
      keyboard: containsAllPrerequisitesDesign?.keyboard ??
          widget.controller.keyboard,
      hintText: containsAllPrerequisitesDesign?.hintText ??
          widget.controller.hintText,
      validator: containsAllPrerequisitesDesign?.validator ??
          widget.controller.validator,
      prefixIcon: containsAllPrerequisitesDesign?.prefixIcon ??
          widget.controller.prefixIcon,
      suffixIcon: containsAllPrerequisitesDesign?.suffixIcon ??
          widget.controller.suffixIcon,
      isReadOnlySave: containsAllPrerequisitesDesign?.isReadOnlySave ??
          widget.controller.isReadOnlySave,
      textInputAction: containsAllPrerequisitesDesign?.textInputAction ??
          widget.controller.textInputAction,
      textAlign: containsAllPrerequisitesDesign?.textAlign ??
          widget.controller.textAlign,
      enable:
          containsAllPrerequisitesDesign?.enable ?? widget.controller.enable,
      readOnly: containsAllPrerequisitesDesign?.readOnly ??
          widget.controller.readOnly,
      isBorder: containsAllPrerequisitesDesign?.isBorder ??
          widget.controller.isBorder,
      borderColor: containsAllPrerequisitesDesign?.borderColor ??
          widget.controller.borderColor,
      backGroundColor: containsAllPrerequisitesDesign?.backGroundColor ??
          widget.controller.backGroundColor,
      borderRadius: containsAllPrerequisitesDesign?.borderRadius ??
          widget.controller.borderRadius,
      obscureText: containsAllPrerequisitesDesign?.obscureText ??
          widget.controller.obscureText,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
      dataKey:
          containsAllPrerequisitesDesign?.dataKey ?? widget.controller.dataKey,
      floatingText: containsAllPrerequisitesDesign?.floatingText ??
          widget.controller.floatingText,
      saveAs:
          containsAllPrerequisitesDesign?.saveAs ?? widget.controller.saveAs,
      regex: containsAllPrerequisitesDesign?.regex ?? widget.controller.regex,
      regexError: containsAllPrerequisitesDesign?.regexError ??
          widget.controller.regexError,
    );

    String? val;
    if (displayController.id != null) {
      val = widget.formController.getDynamicData(
          displayController.id!.replaceAll('{', '').replaceAll('}', ''));
    } else if (displayController.dataKey != null) {
      if (displayController.dataKey!.isNotEmpty) {
        val = widget.formController.getDynamicData(displayController.dataKey!);
      }
    }

    if (val != null && val.isNotEmpty) {
      final currentFormData = val;
      if (constText.text != currentFormData) {
        constText.text = currentFormData;
      }
    }

    if (widget.formController.formData.containsKey(displayController.name)) {
      final currentFormData =
          widget.formController.formData[displayController.name];
      if (constText.text != currentFormData) {
        constText.text = currentFormData;
      }
      widget.formController.saveFieldValue(
        (displayController.name ?? displayController.id ?? ''),
        constText.text,
      );
      if (displayController.saveAs != null &&
          displayController.saveAs!.isNotEmpty) {
        saveToLocal(displayController.saveAs!, constText.text);
      }
    }

    if (!(displayController.readOnly ?? false)) {
      widget.formController.saveFieldValue(
        (displayController.name ?? displayController.id ?? ''),
        constText.text,
      );
    }
    if ((displayController.isReadOnlySave ?? false)) {
      widget.formController.saveFieldValue(
        (displayController.name ?? displayController.id ?? ''),
        constText.text,
      );
    }

    return !containsAllPrerequisites
        ? DynamicTextfield(
            saveAs: displayController.saveAs,
            regex: displayController.regex,
            regexError: displayController.regexError,
            isHintVisible: false,
            key: Key(displayController.id ?? displayController.name ?? ''),
            maxLine: 1,
            maxLength: displayController.maxLength ?? 30,
            textInputAction: displayController.textInputAction,
            controller: constText,
            keyboardType: displayController.keyboard,
            prefixIcon: displayController.prefixIcon != null &&
                    displayController.prefixIcon!.isNotEmpty
                ? IconButton(
                    enableFeedback: false,
                    icon: SizedBox(
                      height: 24,
                      width: 24,
                      child: Image(
                          image: NetworkImage(displayController.prefixIcon!)),
                    ),
                    onPressed: () {},
                  )
                : null,
            readOnly: displayController.readOnly,
            suffixIcon: isobscureText
                ? IconButton(
                    icon: isPassVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isPassVisible = !isPassVisible;
                      });
                    },
                  )
                : displayController.suffixIcon != null &&
                        displayController.suffixIcon!.isNotEmpty
                    ? constText.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: () {
                              setState(() {
                                constText.clear();
                                widget.formController.saveFieldValue(
                                    displayController.name ?? '', '');
                              });
                            },
                          )
                        : null
                    : null,
            hintText: displayController.hintText,
            onChanged: (value) async {
              widget.formController
                  .saveFieldValue(displayController.name ?? '', value);
              saveFieldValues(displayController.name ?? '', value);
              // _validate(value, displayController);
              if (displayController.saveAs != null &&
                  displayController.saveAs!.isNotEmpty) {
                await saveToLocal(displayController.saveAs!, value);
              }
            },
            // validator: displayController.required == true
            //     ? (String? value) {
            //         // _validate(value, displayController);
            //         return errorMessage;
            //       }
            //     : null,
            isBorder: displayController.isBorder,
            floatingText: displayController.floatingText,
            clickedBorderColor: displayController.isBorder == true
                ? displayController.borderColor
                : null,
            backgroundColor: displayController.backGroundColor,
            borderRadius: displayController.borderRadius?.toDouble(),
            obscureText: isPassVisible,
          )
        : SizedBox.shrink();
  }
}
