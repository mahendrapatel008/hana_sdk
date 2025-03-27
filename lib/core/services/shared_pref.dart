// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';


// import 'package:gotham/core/utils/constant.dart';
import 'package:hana_sdk/core/Listeners/locationFetcherNotifier.dart';
import 'package:hana_sdk/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  static initSP() async =>
      _sharedPrefs ??= await SharedPreferences.getInstance();

  static clearSharedPref() async => await _sharedPrefs?.clear();

  bool _locationFetcher = false;

  bool get locationfetcher => _locationFetcher;

  set locationfetcher(bool value) {
    _locationFetcher = value;
    locationFetcherNotifier.value = value; // Notify listeners
  }

  set isLoggedIn(bool? value) =>
      _sharedPrefs?.setBool(kIsLoggedIn, value ?? false);

  bool get isLoggedIn => _sharedPrefs?.getBool(kIsLoggedIn) ?? false;

  // set email(String? value) => _sharedPrefs?.setString(kEmail, value ?? "");

  // String get email => _sharedPrefs?.getString(kEmail) ?? "";

  set userName(String? value) =>
      _sharedPrefs?.setString(kUserName, value ?? "");

  String get attendenceId => _sharedPrefs?.getString(kattendenceId) ?? "";
  set attendenceId(String? value) =>
      _sharedPrefs?.setString(kattendenceId, value ?? "");

  String get locationDatabase =>
      _sharedPrefs?.getString(klocationDatabase) ?? "";
  set locationDatabase(String? value) =>
      _sharedPrefs?.setString(klocationDatabase, value ?? "");

  String get userName => _sharedPrefs?.getString(kUserName) ?? "";

  set hanaDependent(String? value) =>
      _sharedPrefs?.setString(kHanaDependent, value ?? "");

  String get hanaDependent => _sharedPrefs?.getString(kHanaDependent) ?? "";

  set hanaDocumentId(String? value) =>
      _sharedPrefs?.setString(kHanaDocumentId, value ?? "");

  String get hanaDocumentId => _sharedPrefs?.getString(kHanaDocumentId) ?? "";

  set hanaDateDependent(String? value) =>
      _sharedPrefs?.setString(khanaDateDependent, value ?? "");

  String get hanaDateDependent =>
      _sharedPrefs?.getString(khanaDateDependent) ?? "";

  set hanaMonthDependent(String? value) =>
      _sharedPrefs?.setString(khanaMonthDependent, value ?? "");

  String get hanaMonthDependent =>
      _sharedPrefs?.getString(khanaMonthDependent) ?? "";

  set hanaYearDependent(String? value) =>
      _sharedPrefs?.setString(khanaYearDependent, value ?? "");

  String get hanaYearDependent =>
      _sharedPrefs?.getString(khanaYearDependent) ?? "";

  set appFirstPageName(String? value) =>
      _sharedPrefs?.setString(kFirstPageName, value ?? "");

  String get appFirstPageName => _sharedPrefs?.getString(kFirstPageName) ?? "";

  set appModuleName(String? value) =>
      _sharedPrefs?.setString(kModuleName, value ?? "");

  String get appModuleName => _sharedPrefs?.getString(kModuleName) ?? "";

  set accessToken(String? value) =>
      _sharedPrefs?.setString(kAccessToken, value ?? "");

  String get accessToken => _sharedPrefs?.getString(kAccessToken) ?? "";

  set refreshToken(String? value) =>
      _sharedPrefs?.setString(kRefreshToken, value ?? "");

  String get refreshToken => _sharedPrefs?.getString(kRefreshToken) ?? "";

  set sId(String? value) => _sharedPrefs?.setString(ksId, value ?? "");

  String get sId => _sharedPrefs?.getString(ksId) ?? "";

  set fbToken(String? value) => _sharedPrefs?.setString(kFbToken, value ?? "");

  String get fbToken => _sharedPrefs?.getString(kFbToken) ?? "";

  set deviceId(String? value) =>
      _sharedPrefs?.setString(kDeviceId, value ?? "");

  String get deviceId => _sharedPrefs?.getString(kDeviceId) ?? "";

  set appName(String? value) => _sharedPrefs?.setString(kAppName, value ?? "");

  String get appName => _sharedPrefs?.getString(kAppName) ?? "";

  set appRole(String? value) => _sharedPrefs?.setString(kAppRole, value ?? "");

  String get appRole => _sharedPrefs?.getString(kAppRole) ?? "";

  set country(String? value) => _sharedPrefs?.setString(kCountry, value ?? "");

  String get country => _sharedPrefs?.getString(kCountry) ?? "";

  set deviceInfo(String? value) =>
      _sharedPrefs?.setString(kDeviceInfo, value ?? "");

  String get deviceInfo => _sharedPrefs?.getString(kDeviceInfo) ?? "";

  // New properties for latitude and longitude and address
  set latitude(double? value) =>
      _sharedPrefs?.setDouble('latitude', value ?? 0.0);
  double get latitude => _sharedPrefs?.getDouble('latitude') ?? 0.0;

  set longitude(double? value) =>
      _sharedPrefs?.setDouble('longitude', value ?? 0.0);
  double get longitude => _sharedPrefs?.getDouble('longitude') ?? 0.0;

  set locationAddress(String? value) =>
      _sharedPrefs?.setString('locationAddress', value ?? '');
  String get locationAddress =>
      _sharedPrefs?.getString('locationAddress') ?? '';

  set cameraImage(String? value) =>
      _sharedPrefs?.setString('cameraImage', value ?? '');
  String get cameraImage => _sharedPrefs?.getString('cameraImage') ?? '';
  set galleryImage(File? value) =>
      _sharedPrefs?.setString('galleryImage', value?.path ?? '');
  File? get galleryImage {
    final path = _sharedPrefs?.getString('galleryImage');
    if (path != null && path.isNotEmpty) {
      return File(path);
    }
    return null; // Return null if no valid path is found
  }

  // Save and retrieve markers as a JSON string
  set markers(List<Map<String, dynamic>> markers) {
    String markersJson = jsonEncode(markers);
    _sharedPrefs?.setString('markers', markersJson);
  }

  // Get a string value
  String? getString(String key) {
    return _sharedPrefs?.getString(key);
  }

  // Set a string value
  Future<void> setString(String key, String value) async {
    await _sharedPrefs?.setString(key, value);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _sharedPrefs?.clear();
  }

  // Check if a key exists
  bool containsKey(String key) {
    return _sharedPrefs?.containsKey(key) ?? false;
  }

  // Remove a key
  Future<void> remove(String key) async {
    await _sharedPrefs?.remove(key);
  }

  List<Map<String, dynamic>> get markers {
    String? markersJson = _sharedPrefs?.getString('markers');
    if (markersJson != null && markersJson.isNotEmpty) {
      return List<Map<String, dynamic>>.from(jsonDecode(markersJson));
    } else {
      return [];
    }
  }
}
