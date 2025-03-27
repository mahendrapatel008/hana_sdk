import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_event.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';

class FormController extends ChangeNotifier {
  Map<String, dynamic> formData = {};
  List<String> formNameData = [];
  Map<String, dynamic> saveDynamicData = {};
  Map<String, dynamic> dynamicData = {};
  Map<String, dynamic> dynamicElementsKeyValues = {};
  dynamic dynamicLookUp;
  String otpData = '';
  Map<String, String> validationErrors = {};

  FormController();

  void submitForm() {
    print('Form submitted: $formData');
    print('Form submitted: $saveDynamicData');
    String userName =
        formData.containsKey('username') ? formData['username'] : '';
    String appName = formData.containsKey('AppName') ? formData['AppName'] : '';
    String appRole = formData.containsKey('AppRole') ? formData['AppRole'] : '';
    String appFirstPageName = formData.containsKey('AppFirstPageName')
        ? formData['AppFirstPageName']
        : '';
    String appModuleName =
        formData.containsKey('AppModuleName') ? formData['AppModuleName'] : '';
    print('bdbdbdddbdb${appName}');
    userName.isNotEmpty ? SharedPrefs().userName = userName : null;
    appName.isNotEmpty ? SharedPrefs().appName = appName : null;
    appRole.isNotEmpty ? SharedPrefs().appRole = appRole : null;
    appFirstPageName.isNotEmpty
        ? SharedPrefs().appFirstPageName = appFirstPageName
        : null;
    appModuleName.isNotEmpty
        ? SharedPrefs().appModuleName = appModuleName
        : null;
  }

  void setdynamicElementsKeyValues(String key, String value) {
    dynamicElementsKeyValues[key] = value;
  }

  void cleardynamicElementsKeyValues(String key) {
    if (dynamicElementsKeyValues.containsKey(key)) {
      dynamicElementsKeyValues.remove(key);
      print('Key "$key" has been removed.');
    } else {
      print('Key "$key" does not exist.');
    }
  }

  void setValidationState(String fieldName, String? errorMessage) {
    print('setValidationState  {$fieldName => $errorMessage}');
    if (errorMessage == null) {
      validationErrors.remove(fieldName);
    } else {
      validationErrors[fieldName] = errorMessage;
    }
    notifyListeners();
  }

  bool isFormValid() {
    return validationErrors.isEmpty;
  }

  void saveFieldValue(String fieldName, dynamic value) {
    formData[fieldName] = value;
    notifyListeners();
  }

  void saveFieldName(String? fieldName) {
    if (fieldName == null || fieldName.isEmpty) {
      return;
    } else {
      formNameData.add(fieldName);
    }
    print('saveFieldName: $formNameData');
    notifyListeners();
  }

  List savePrerequisitesNameData = [];
  void savePrerequisitesName(BuildContext context, String? fieldName) {
    if (fieldName == null) {
      return;
    }

    if (savePrerequisitesNameData.contains(fieldName)) {
      savePrerequisitesNameData.remove(fieldName);
    } else {
      savePrerequisitesNameData.add(fieldName);
    }
    BlocProvider.of<RefreshBloc>(context).add(RefreshFormEvent(check: ''));
  }

  void removePrerequisitesName(BuildContext context, String? fieldName) {
    if (fieldName == null) return;

    savePrerequisitesNameData.remove(fieldName);
    print('Removed field name: $fieldName');
    print('Updated prerequisites list: $savePrerequisitesNameData');
    BlocProvider.of<RefreshBloc>(context).add(RefreshFormEvent(check: ''));
  }

  List getPrerequisitesName() {
    return savePrerequisitesNameData;
  }

  void saveFieldNameData(Map<String, dynamic> data, bool? previousClear) {
    if (previousClear == true) {
      dynamicData.clear();
    }
    if (dynamicData.isNotEmpty) {
      data.forEach((key, value) {
        if (dynamicData.containsKey(key)) {
          dynamicData[key] = value;
        } else {
          dynamicData[key] = value;
        }
        print('NameData:>>a $value');
      });
    } else {
      dynamicData.addAll(data);
    }
    print('NameData:>> $data');
    print('NameData:>> $dynamicData');
    notifyListeners();
  }

  void saveFieldNameLookUp(List<dynamic>? data, bool? previousClear) {
    dynamicLookUp = data;
    notifyListeners();
  }

  String? getDynamicData(
    String fieldName,
  ) {
    return dynamicData[fieldName];
  }

  void updateFieldNameData(Map<String, dynamic> data) {
    if (dynamicData.isNotEmpty) {
      data.forEach((key, value) {
        print('Key:???? $key, Value: $value');
        if (dynamicData.containsKey(key)) {
          dynamicData[key] = value;
        }
      });
    } else {
      dynamicData.addAll(data);
    }
    print('NameData: $dynamicData');
    notifyListeners();
  }

  void clearFieldNameData() {
    dynamicData.clear();
    notifyListeners();
  }
}
