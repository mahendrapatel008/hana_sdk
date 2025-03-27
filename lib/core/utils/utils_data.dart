import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:math' as Math;

import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

String generateFourDigitCode() {
  Random random = Random();
  int randomCode = 1000 + random.nextInt(9000);
  String fourDigitCode = randomCode.toString();
  return fourDigitCode;
}

const _chars =
    // 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

Future<String> getAndroidId() async {
  try {
    String deviceId = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String osName = Platform.isIOS ? "iOS" : "Android";
    if (osName == "Android") {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Use androidId for Android
    } else if (osName == "iOS") {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ??
          getRandomString(16); // Use identifierForVendor for iOS
    }
    print("deviceId======>>$deviceId");
    // var identifier = await UniqueIdentifier.serial;

    print("deviceId======>>$deviceId");
    SharedPrefs().deviceId = deviceId;
    return deviceId;
  } catch (e) {
    print(e);
    return "";
  }
}

String toExact(double value) {
  var sign = "";
  if (value < 0) {
    value = -value;
    sign = "-";
  }
  var string = value.toString();
  var e = string.lastIndexOf('e');
  if (e < 0) return "$sign$string";
  assert(string.indexOf('.') == 1);
  var offset =
      int.parse(string.substring(e + (string.startsWith('-', e + 1) ? 1 : 2)));
  var digits = string.substring(0, 1) + string.substring(2, e);
  if (offset < 0) {
    return "${sign}0.${"0" * ~offset}$digits";
  }
  if (offset > 0) {
    if (offset >= digits.length) return sign + digits.padRight(offset + 1, "0");
    return "$sign${digits.substring(0, offset + 1)}"
        ".${digits.substring(offset + 1)}";
  }
  return digits;
}

Future<String?> getCountry() async {
  var deviceInfo = DeviceInfoPlugin();
  String? countryCode;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    countryCode = androidInfo.systemFeatures.contains('country')
        ? androidInfo.systemFeatures[0]
        : null;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    countryCode = iosInfo.utsname.machine.split('_').last;
  }

  return countryCode;
}

String getCountryFromLocale() {
  var locale = Intl.getCurrentLocale();
  return locale
      .split('_')
      .last; // Locale code is in the format "language_COUNTRY"
}

String getCountryFromLocaleA() {
  var locale = ui.window.locale.toString();
  return locale.split('_').last;
}

String getCountryFromLocaleB(BuildContext context) {
  var locale = Localizations.localeOf(context).toString();
  return locale.split('_').last;
}

Future<String> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String osName = Platform.isIOS ? "iOS" : "Android";
  if (osName == "iOS") {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    var model = iosInfo.utsname.machine.toString();
    String deviceName = "$osName-$model";
    print("deviceName======>>$deviceName");
    SharedPrefs().deviceInfo = deviceName;
    return deviceName;
  } else {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var model = androidInfo.model.toString();
    String osVersion = androidInfo.version.release.toString();
    var manufacturer = androidInfo.manufacturer.toString();
    var brand = androidInfo.brand.toString();
    String deviceName = "$osName-$osVersion, $manufacturer, $brand, $model";
    print("deviceName======>>$deviceName");
    SharedPrefs().deviceInfo = deviceName;
    return deviceName;
  }
}

void showSnackBar(BuildContext context, String message, String undo) {
  // Create a SnackBar
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    duration: const Duration(seconds: 3),
    // Set the duration for which the SnackBar will be displayed
    action: SnackBarAction(
      label: undo.isNotEmpty ? undo : "OK",
      onPressed: () {
        // Code to undo the action
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

double getDistanceFromLatLonInKm(
    double lat1, double lon1, double lat2, double lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(deg2rad(lat1)) *
          Math.cos(deg2rad(lat2)) *
          Math.sin(dLon / 2) *
          Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

double deg2rad(deg) {
  return deg * (Math.pi / 180);
}

String generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

String currentTimeDetails() {
  return DateFormat('dd-MM-yy HH:mm:ss').format(DateTime.now());
}

String getCurrentDateTime() {
  return DateFormat('dd-MM-yy HH:mm:ss').format(DateTime.now());
}

String generateCurrentTime() {
  final now = DateTime.now();
  final timeFormatter =
      DateFormat('h:mm a'); // 'h' is for 12-hour format, 'a' is for AM/PM
  return timeFormatter.format(now);
}

String generateCurrentDate() {
  final now = DateTime.now();
  final dateFormatter =
      DateFormat('dd-MM-yy'); // 'dd' for day, 'MM' for month, 'yy' for year
  return dateFormatter.format(now);
}

String formatDate(String dateString) {
  DateFormat inputFormat = DateFormat('dd-MM-yy HH:mm:ss');
  DateTime dateTime = inputFormat.parse(dateString);
  DateFormat outputFormat1 = DateFormat('dd-MM-yyyy');
  DateFormat outputFormat2 = DateFormat('hh:mm a');
  String fnalOutput =
      '${outputFormat1.format(dateTime)} at ${outputFormat2.format(dateTime)}';
  return fnalOutput;
}

Color? hexToColor(String? hex) {
  if (hex == null || hex.isEmpty) {
    return null; // Return null if hex is null or empty
  } else {
    hex = hex.replaceAll("#", "");

    // Check if the hex string contains only valid hexadecimal characters
    if (!_isValidHex(hex)) {
      return null; // Return null if the hex string is invalid
    }

    return hex.length == 8
        ? Color(int.parse(hex, radix: 16))
        : Color(int.parse("FF$hex", radix: 16));
  }
}

// Helper function to check if the string contains only valid hex characters (0-9, A-F)
bool _isValidHex(String hex) {
  final hexPattern = RegExp(r'^[0-9A-Fa-f]+$');
  return hexPattern.hasMatch(hex);
}

// String saveDynamicData = '';
Map<String, dynamic> saveDynamicData = {};
void saveDynamicValue(String fieldName, dynamic value) {
  saveDynamicData[fieldName] = value;
}

String dynamicPageNameString = '';
String? getDynamicValue(
  String? fieldName,
) {
  return saveDynamicData[fieldName ?? ''].toString();
}

Map<String, dynamic> reFormData = {};
void saveReFieldValue(Map<String, dynamic> value) {
  reFormData = value;
}

class GlobalKeyProvider {
  static final GlobalKeyProvider _instance = GlobalKeyProvider._internal();
  factory GlobalKeyProvider() => _instance;

  GlobalKeyProvider._internal();

  final GlobalKey repaintBoundaryKey = GlobalKey();
}

final globalKeyProvider = GlobalKeyProvider();

List<String> savePageData = [];
var hanaVar1;
List<Map<String, dynamic>>? universalListData;
int? universalIndex;
String hanaUser = '';
String hanaToken = '';
String hanaUserId = '';
String hanaDependent = '';
String hanaDateDependent = '';
String hanaMonthDependent = '';
String hanaYearDependent = '';

Future<void> handleNavigation(
    String? pageName, OnClickData? onClickData, BuildContext context) async {
  if (pageName == null || pageName.isEmpty) return;

  if (onClickData?.popCount == 'all') {
    Navigator.popUntil(context, (route) => route.isFirst);
    savePageData.clear();
  } else if (onClickData?.popCount != null) {
    int popCount = int.parse(onClickData!.popCount!);
    for (var i = 0; i < popCount; i++) {
      context.pop();
    }
  }

  // context.push('/dynamic_form', extra: {'token': '1', 'pageName': pageName});
}

Future<String> resolveDynamicValue(
    String? dataKey, String? label, FormController formController) async {
  if (dataKey == null || dataKey.isEmpty) {
    return label ?? '...';
  }

  if (dataKey.contains('{localVar}')) {
    final regex = RegExp(r'\{localVar\},(.*?\{(\w+)\}.*?)');
    final match = regex.firstMatch(dataKey);

    if (match != null) {
      final fullTemplate = match.group(1)!; // e.g., "{local},{userStoreId}"
      final localKey = match.group(2)!; // e.g., "userStoreId"
      try {
        final localValue = await getLocalStorageValue(localKey);
        if (localValue != null) {
          return (fullTemplate.replaceAll('{$localKey}', localValue))
              .toString();
        }
      } catch (e) {
        print("Error accessing local key: $e");
      }
    }
  } else if (dataKey.contains('{responseVar}')) {
    final regex = RegExp(r'\{responseVar\},(.*?\{(.+?)\}.*?)');
    final match = regex.firstMatch(dataKey);

    if (match != null) {
      final fullTemplate = match.group(1)!;
      final responseKey = match.group(2)!;
      try {
        final responseValue = formController.dynamicData[responseKey];
        String data;
        if (responseValue is String) {
          data = responseValue;
        } else {
          data = jsonEncode(responseValue);
        }

        if (responseValue != null) {
          return (fullTemplate.replaceAll('{$responseKey}', data));
          // return data;
        }
      } catch (e) {
        print("Error accessing response key: $e");
      }
    }
  } else if (dataKey.contains('{listVar}')) {
    final regex = RegExp(r'\{listVar\},(.*?\{(.+?)\}.*?)');
    final match = regex.firstMatch(dataKey);

    if (match != null) {
      final fullTemplate = match.group(1)!; // e.g., "{response},{someKey}"
      final responseKey = match.group(2)!; // e.g., "someKey"
      try {
        final responseValue = getDynamicValue(responseKey);
        if (responseValue != null) {
          return (fullTemplate.replaceAll(
                  '{$responseKey}', responseValue.toString()))
              .toString();
        }
      } catch (e) {
        print("Error accessing list key: $e");
      }
    }
  }
  return label ?? '...'; // Default fallback
}

/// Helper function to handle nested key retrieval
dynamic getValueFromNestedKey(Map<String, dynamic> data, String nestedKey) {
  try {
    final keys = nestedKey.split('.'); // Split by '.' for nested access
    dynamic value = data;

    for (final key in keys) {
      if (value is List && key.startsWith('[') && key.endsWith(']')) {
        final index = int.parse(key.substring(1, key.length - 1));
        value = value[index];
      } else if (value is Map<String, dynamic>) {
        value = value[key];
      } else {
        return null; // Key not found
      }
    }
    return value;
  } catch (e) {
    print("Error accessing nested key: $e");
    return null;
  }
}

Future<String> getIpAddress() async {
  final NetworkInfo networkInfo = NetworkInfo();

  // Get the WiFi IP address
  final wifiIp = await networkInfo.getWifiIP();

  // If connected to WiFi, return the WiFi IP address
  if (wifiIp != null) {
    return wifiIp;
  }

  // If not connected to WiFi, handle cellular or other cases
  return "Unable to fetch IP address";
}

Future<String?> getLocalStorageValue(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> saveToLocal(String key, dynamic value) async {
  print("Saving key: $key, value: $value");
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check type and save appropriately
  if (value is String ||
      value is int ||
      value is bool ||
      value is double ||
      value is List<String>) {
    // Directly store supported types
    await prefs.setString(key, value.toString());
  } else if (value is Map<String, dynamic> || value is List) {
    // Serialize map or list to a JSON string
    final jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  } else {
    throw Exception('Unsupported type for saving to local storage');
  }
  print("Saved Data for ${prefs.getKeys()}");
  // Debug print for verification
  print("Saved value for $key: ${prefs.get(key)}");
  print("Saved value for ${prefs.get("accessToken")}");
}

dynamic getValueFromPath(Map<String, dynamic> json, String path) {
  dynamic current = json;

  // Split the path into keys and process each part
  final keys = path.split('.');

  for (final key in keys) {
    // Handle array indices in keys (e.g., data[0])
    final match = RegExp(r'(\w+)(\[(\d+)\])?').firstMatch(key);
    if (match != null) {
      final mapKey = match.group(1); // e.g., "data"
      final index =
          match.group(3) != null ? int.parse(match.group(3)!) : null; // e.g., 0

      if (mapKey != null) {
        if (current is Map<String, dynamic> && current.containsKey(mapKey)) {
          current = current[mapKey];
        } else {
          throw Exception("Key '$mapKey' not found in JSON.");
        }
      }

      if (index != null) {
        if (current is List && index < current.length) {
          current = current[index];
        } else {
          throw Exception("Index '$index' out of range.");
        }
      }
    } else {
      throw Exception("Invalid path segment: $key");
    }
  }

  return current;
}
