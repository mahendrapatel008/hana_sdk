import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/res/colours.dart';
import 'package:hana_sdk/core/services/font_services.dart';

class DynamicTextfield extends StatefulWidget {
  const DynamicTextfield({
    super.key,
    this.curFocusNode,
    this.formController,
    this.nextFocusNode,
    this.hint,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.onTap,
    this.textAlign,
    this.enable,
    this.readOnly,
    this.inputFormatter,
    this.minLine,
    this.maxLine,
    this.maxLength,
    this.prefixIcon,
    this.isHintVisible = true,
    this.prefixText,
    this.hintText,
    this.autofillHints,
    this.semantic,
    this.clickedBorderColor,
    this.isBorder,
    this.floatingText,
    this.saveAs,
    this.name,
    this.id,
    this.regex,
    this.regexError,
    this.backgroundColor,
    this.borderRadius,
    this.autovalidateMode = AutovalidateMode.always, // Set a default
  });
  final AutovalidateMode autovalidateMode; // Add this new field
  final FocusNode? curFocusNode;
  final FocusNode? nextFocusNode;
  final String? hint;
  final Function(String)? validator;
  final Function(String)? onChanged;
  final Function? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obscureText;
  final int? minLine;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final bool? enable;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final bool isHintVisible;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? hintText;
  final Iterable<String>? autofillHints;
  final String? semantic;
  final String? saveAs;
  final String? name;
  final String? id;
  final String? regex;
  final String? regexError;
  final Color? clickedBorderColor;
  final bool? isBorder;
  final bool? floatingText;
  final Color? backgroundColor;
  final double? borderRadius;
  final FormController? formController;

  @override
  State<DynamicTextfield> createState() => _DynamicTextfieldState();
}

class _DynamicTextfieldState extends State<DynamicTextfield> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(DynamicTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the passed controller has changed, and if so, update it accordingly
    if (widget.controller != null &&
        widget.controller != oldWidget.controller) {
      _controller = widget.controller!;
    }
  }

  String? validateWithRegex(String? value) {
    if (widget.regex != null && widget.regex!.isNotEmpty) {
      final RegExp regexPattern = RegExp(widget.regex!);
      if (value == null || value.isEmpty) {
        return "This field is required";
      }
      if (!regexPattern.hasMatch(value)) {
        return widget.regexError != null && widget.regexError!.isNotEmpty
            ? widget.regexError
            : "Invalid format"; // Customize this error message
      }
    }
    return null;
  }

  @override
  void dispose() {
    // If this widget owns the controller, dispose of it
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: widget.isBorder == true
            ? widget.clickedBorderColor ?? Colors.black
            : Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.circular(
        widget.borderRadius ?? 0,
      ),
    );

    return TextFormField(
      key: widget.key,
      autovalidateMode:
          widget.autovalidateMode, // Use the mode specified in the widget
      maxLength: widget.maxLength ?? 30,
      readOnly: widget.readOnly ?? false,
      controller: _controller,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textAlign: widget.textAlign ?? TextAlign.start,
      minLines: widget.minLine ?? 1,
      maxLines: widget.maxLine ?? 10,
      inputFormatters: widget.inputFormatter,
      style: FontService.custom(),
      cursorColor: Colours.textColor,
      decoration: InputDecoration(
        counterText: '',
        prefixText: widget.prefixText,
        hintText: widget.hintText,
        labelText: widget.floatingText == true ? widget.hintText : null,
        suffixIcon: widget.readOnly == true
            ? null
            : widget.maxLength! > 1
                ? widget.suffixIcon
                : null,
        prefixIcon: widget.prefixIcon != null
            ? widget.maxLength! > 1
                ? widget.prefixIcon
                : null
            : null,
        filled: widget.backgroundColor != null,
        fillColor: widget.backgroundColor,
        enabledBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colours.red),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colours.red),
        ),
        focusedBorder: border,
        // floatingLabelBehavior: widget.isBorder == true
        //     ? FloatingLabelBehavior.auto
        //     : FloatingLabelBehavior.never,
      ),
      validator: widget.regex != null && widget.regex!.isNotEmpty
          ? (value) {
              String? error = validateWithRegex(value);
              if (error != null) return error;

              if (widget.validator != null) {
                return widget.validator!(value ?? "");
              }
              return null;
            }
          : widget.validator as String? Function(String?)?,

      onChanged: (value) {
        // Preserve cursor position on text change
        final cursorPosition = _controller.selection;
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        // Set the cursor position back to where it was
        _controller.value = _controller.value.copyWith(
          selection: cursorPosition,
        );
      },
      onTap: widget.onTap as void Function()?,
      onFieldSubmitted: (value) async {
        fieldFocusChange(
          context,
          widget.curFocusNode ?? FocusNode(),
          widget.nextFocusNode,
        );
      },
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
