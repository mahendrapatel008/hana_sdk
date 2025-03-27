import 'package:flutter/material.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_form.dart';

class DynamicFormController extends ChangeNotifier {
  late DynamicForm formModel;
  Map<String, dynamic> formData = {};

  Future<void> loadFormData(Map<String, dynamic> json) async {
    formModel = await DynamicForm.fromJson(json, true);
    notifyListeners();
  }

  void updateFormData(String field, dynamic value) {
    formData[field] = value;
    notifyListeners();
  }

  void submitForm() {
    print("Form submitted with data: $formData");
  }

  bool validateForm() {
    return true;
  }
}
