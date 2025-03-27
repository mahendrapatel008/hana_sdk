import 'dart:convert';

import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar_model.dart';
import 'package:hana_sdk/core/model/external_api_call_model.dart';
import 'package:hana_sdk/core/services/location_fetcher.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicForm {
  final String name;
  final String? moduleName;
  final List<FormSectionMain> form;
  final DynamicAppbarModel? dynamicAppbar;
  final Map<String, dynamic>? dynamicDataChanger;
  final List<ExternalApiCallModel>? dynamicLookup;

  DynamicForm({
    required this.form,
    required this.name,
    this.moduleName,
    this.dynamicAppbar,
    this.dynamicDataChanger,
    this.dynamicLookup,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'moduleName': moduleName,
      'form': form.map((section) => section.toJson()).toList(),
      'dynamicAppbar': dynamicAppbar?.toJson(),
      'dynamicLookup': dynamicLookup?.map((lookup) => lookup.toJson()).toList(),
      'dynamicDataChanger': dynamicDataChanger,
    };
  }

  static Future<DynamicForm> fromJson(
      Map<String, dynamic> json, bool? clear) async {
    String jsonString = json['data'][0]['sectionData']['mobilejson']['data'];
    String moduleNameString =
        json['data'][0]['sectionData']['mobilejson']['moduleName'] ?? "";
    String nameString = json['data'][0]['sectionData']['mobilejson']['name'];
    if (jsonString.isEmpty) {
      throw Exception("JSON string is empty");
    }

    Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed to decode jsonString: $e");
    }

    List<ExternalApiCallModel> jsonLookupData = [];
    try {
      var rawLookups = json['data'][0]['sectionData']['mobilejson']['lookup'];

      if (rawLookups is List) {
        jsonLookupData = rawLookups.map((lookup) {
          if (lookup is Map<String, dynamic>) {
            return ExternalApiCallModel.fromJson(lookup);
          } else {
            throw Exception("Invalid lookup item: $lookup");
          }
        }).toList();
      } else if (rawLookups is String && rawLookups.isNotEmpty) {
        final decodedLookups = jsonDecode(rawLookups) as List<dynamic>;
        jsonLookupData = decodedLookups.map((lookup) {
          if (lookup is Map<String, dynamic>) {
            return ExternalApiCallModel.fromJson(lookup);
          } else {
            throw Exception("Invalid lookup item: $lookup");
          }
        }).toList();
      } else {
        throw Exception("Invalid format for jsonLookups: $rawLookups");
      }
    } catch (e) {
      print("Error decoding jsonLookups: $e");
    }

    for (var lookup in jsonLookupData) {
      if (lookup.body != null) {
        await resolveLocalPlaceholders(lookup.body!);
      }
      if (lookup.headers != null) {
        await resolveLocalPlaceholders(lookup.headers!);
      }
      if (hanaVar1 != null) {
        resolveLocalPlaceholders(lookup.body!);
      }
      if (hanaVar1 != null) {
        resolveLocalPlaceholders(lookup.headers!);
      }
    }

    var formSections = (jsonData['form'] as List).map((sectionJson) {
      return FormSectionMain.fromJson(sectionJson['section']);
    }).toList();

    return DynamicForm(
      form: formSections,
      moduleName: moduleNameString,
      name: nameString,
      dynamicLookup: jsonLookupData,
      dynamicAppbar: jsonData['appbar'] != null
          ? DynamicAppbarModel.fromJson(
              jsonData['appbar'] as Map<String, dynamic>)
          : null,
    );
  }
}

Future<void> resolveLocalPlaceholders(Map<String, dynamic> mapData) async {
  for (var key in mapData.keys) {
    var value = mapData[key];

    if (value is String && value.contains('{localVar}')) {
      final regex = RegExp(r'\{localVar\},(.?\{(\w+)\}.?)');
      final match = regex.firstMatch(value);

      if (match != null) {
        final fullTemplate = match.group(1)!;
        final localKey = match.group(2)!;

        try {
          final localValue = await getLocalStorageValue(localKey);

          if (localValue != null) {
            mapData[key] =
                fullTemplate.replaceAll('{$localKey}', localValue.toString());
          } else {
            throw Exception('localVar value for key $localKey not found.');
          }
        } catch (e) {
          print("Error fetching local value for key $localKey: $e");
        }
      }
    } else if (value is Map<String, dynamic>) {
      await resolveLocalPlaceholders(value);
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        if (value[i] is Map<String, dynamic>) {
          await resolveLocalPlaceholders(value[i]);
        } else if (value[i] is String && value[i].contains('{localVar}')) {
          final regex = RegExp(r'\{localVar\},(.?\{(\w+)\}.?)');
          final match = regex.firstMatch(value[i]);

          if (match != null) {
            final fullTemplate = match.group(1)!;
            final localKey = match.group(2)!;
            try {
              final localValue = await getLocalStorageValue(localKey);

              if (localValue != null) {
                value[i] = fullTemplate.replaceAll(
                    '{$localKey}', localValue.toString());
              } else {
                throw Exception('localVar value for key $localKey not found.');
              }
            } catch (e) {
              print("Error fetching local value for key $localKey: $e");
            }
          }
        }
      }
    }
    if (value is String && value.contains('{listIndex}')) {
      final regex = RegExp(r'\{listIndex\},(.?\{(\w+)\}.?)');
      final match = regex.firstMatch(value);

      if (match != null) {
        final fullTemplate = match.group(1)!;
        final localKey = match.group(2)!;

        try {
          final localValue = await hanaVar1[localKey];

          if (localValue != null) {
            mapData[key] =
                fullTemplate.replaceAll('{$localKey}', localValue.toString());
          } else {
            throw Exception('listIndex value for key $localKey not found.');
          }
        } catch (e) {
          print("Error fetching local value for key $localKey: $e");
        }
      }
    } else if (value is Map<String, dynamic>) {
      await resolveLocalPlaceholders(value);
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        if (value[i] is Map<String, dynamic>) {
          await resolveLocalPlaceholders(value[i]);
        } else if (value[i] is String && value[i].contains('{listIndex}')) {
          final regex = RegExp(r'\{listIndex\},(.?\{(\w+)\}.?)');
          final match = regex.firstMatch(value[i]);

          if (match != null) {
            final fullTemplate = match.group(1)!;
            final localKey = match.group(2)!;
            try {
              final localValue = await hanaVar1[localKey];

              if (localValue != null) {
                value[i] = fullTemplate.replaceAll(
                    '{$localKey}', localValue.toString());
              } else {
                throw Exception('listIndex value for key $localKey not found.');
              }
            } catch (e) {
              print("Error fetching local value for key $localKey: $e");
            }
          }
        }
      }
    }
    if (value is String && value.contains('{systemVar}')) {
      final regex = RegExp(r'\{systemVar\},(.?\{(\w+)\}.?)');
      final match = regex.firstMatch(value);

      if (match != null) {
        final fullTemplate = match.group(1)!;
        final controlKey = match.group(2)!;

        try {
          String controlValue = '';
          if (controlValue == 'randomString') {
            controlValue = getRandomString(11);
          }
          if (controlValue == 'createdAt') {
            controlValue = generateId();
          }
          if (controlValue == 'getCurrentDateTime') {
            controlValue = getCurrentDateTime();
          }
          if (controlValue == 'getCurrentTime') {
            controlValue = generateCurrentTime();
          }
          if (controlValue == 'getCurrentDate') {
            controlValue = generateCurrentDate();
          }
          if (controlKey == 'ip') {
            controlValue = await getIpAddress();
          }
          if (controlKey == 'device') {
            controlValue = await getDeviceInfo();
          }
          if (controlKey == 'latitude' ||
              controlKey == 'longitude' ||
              controlKey == 'address') {
            await fetchCurrentLocation("{name} {locality}, {country}");
            if (controlKey == 'latitude') {
              controlValue = SharedPrefs().latitude.toString();
            }
            if (controlKey == 'longitude') {
              controlValue = SharedPrefs().longitude.toString();
            }
            if (controlKey == 'address') {
              controlValue = SharedPrefs().locationAddress.toString();
            }
          }

          if (controlValue.isNotEmpty) {
            mapData[key] = fullTemplate.replaceAll(
                '{$controlKey}', controlValue.toString());
            hanaVar1;
          } else {
            throw Exception('systemVar value for key $controlKey not found.');
          }
        } catch (e) {
          print("Error fetching systemVar value for key $controlKey: $e");
        }
      }
    } else if (value is Map<String, dynamic>) {
      await resolveLocalPlaceholders(value);
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        if (value[i] is Map<String, dynamic>) {
          await resolveLocalPlaceholders(value[i]);
        } else if (value[i] is String && value[i].contains('{systemVar}')) {
          final regex = RegExp(r'\{systemVar\},(.?\{(\w+)\}.?)');
          final match = regex.firstMatch(value[i]);

          if (match != null) {
            final fullTemplate = match.group(1)!;
            final localKey = match.group(2)!;
            try {
              final localValue = await getLocalStorageValue(localKey);

              if (localValue != null) {
                value[i] = fullTemplate.replaceAll(
                    '{$localKey}', localValue.toString());
                hanaVar1;
              } else {
                throw Exception('systemVar value for key $localKey not found.');
              }
            } catch (e) {
              print("Error fetching systemVar value for key $localKey: $e");
            }
          }
        }
      }
    }
  }
}

class FormSectionMain {
  final dynamic fields;

  FormSectionMain({
    required this.fields,
  });

  factory FormSectionMain.fromJson(Map<String, dynamic> json) {
    return FormSectionMain(
      fields: json['field'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "field": fields,
    };
  }
}

class FormSection {
  final List<dynamic> fields;

  FormSection({
    required this.fields,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      fields: json['fields'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fields": fields,
    };
  }
}
