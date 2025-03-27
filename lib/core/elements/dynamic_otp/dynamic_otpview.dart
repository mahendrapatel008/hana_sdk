import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_otp/dynamic_otp_model.dart';

class DynamicOtpview extends StatelessWidget {
  final DynamicOtpViewModel model;
  final FormController formController;
  const DynamicOtpview({
    super.key,
    required this.model,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: model.numberOfFields ?? 4,
      borderWidth: model.borderWidth ?? 2.0,
      showFieldAsBox: model.showFieldAsBox ?? true,
      fieldWidth: model.fieldWidth ?? 40.0,
      fieldHeight: model.fieldHeight,
      borderColor: model.borderColor ?? Colors.white,
      focusedBorderColor: model.focusedBorderColor ?? Colors.white,
      fillColor: model.fillColor ?? Colors.white,
      textStyle: TextStyle(
        fontFamily: model.fontName,
        fontSize: model.fontSize,
        fontWeight: model.fontWeight,
        color: model.textColor ?? Colors.white,
      ),
      cursorColor: model.cursorColor,
      onCodeChanged: (String code) {},
      onSubmit: (String verificationCode) {
        formController.otpData = verificationCode;
        formController.saveFieldValue(model.name ?? '', verificationCode);
      },
    );
  }
}
