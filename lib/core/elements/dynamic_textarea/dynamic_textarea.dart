import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_textarea/dynamic_textarea_model.dart';

class DynamicTextArea extends StatefulWidget {
  final DynamicTextAreaModel controller;
  final FormController formController;

  const DynamicTextArea({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicTextArea> createState() => _DynamicTextAreaState();
}

class _DynamicTextAreaState extends State<DynamicTextArea> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.controller.initialText ?? '',
    );
    _focusNode = FocusNode();

    // Listen to the focus changes and trigger rebuild
    _focusNode.addListener(() {
      setState(() {}); // This triggers rebuild to change the border color
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: widget.controller.paddingVertical ?? 12.0,
        horizontal: widget.controller.paddingHorizontal ?? 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.controller.radius?.toDouble() ?? 8),
        ),
        color: widget.controller.backGroundColor,
        border: Border.all(
          width: widget.controller.borderWidth?.toDouble() ?? 2,
          color: _focusNode.hasFocus
              ? widget.controller.focusBorderColor ??
                  widget.controller.borderColor ??
                  Colors.transparent
              : widget.controller.borderColor ?? Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.controller.shadowColor ?? Colors.transparent,
            blurRadius: widget.controller.shadowBlurRadius ?? 10.0,
            offset: Offset(
              widget.controller.shadowOffsetX ?? 4.0,
              widget.controller.shadowOffsetY ?? 4.0,
            ),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        maxLines: null,
        maxLength: widget.controller.maxLength,
        style: TextStyle(
          color: widget.controller.textColor,
          fontSize: widget.controller.fontSize ?? 16.0,
          fontWeight: widget.controller.fontWeight ?? FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: widget.controller.placeholder,
          hintStyle: TextStyle(
            color: widget.controller.placeholderColor?.withOpacity(0.5),
          ),
          border: InputBorder.none,
          counterText: "",
        ),
        onChanged: (value) {
          widget.formController.saveFieldValue(
            widget.controller.name ?? '',
            value,
          );
        },
      ),
    );
  }
}
