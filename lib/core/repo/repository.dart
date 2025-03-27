import 'dart:convert';


import 'package:dartz/dartz.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_data.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_form.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar_model.dart';
import 'package:hana_sdk/core/repo/common_repo.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/constants.dart';
import 'package:hana_sdk/network/api_result_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiFormRepository {
  ApiFormRepository();
  final CommonRepository _repo = CommonRepository();
  String? pageName;

  Future<DynamicForm> getFormJsonString({
    required String apiToken,
    required String formCode,
  }) async {
    DynamicForm formJsonData = DynamicForm(
      name: '',
      form: [],
      dynamicAppbar: DynamicAppbarModel(),
    );

    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.getData(
      collectionName: dynamic_app,
      query: {"_id": formCode},
      projection: {},
      limit: 100,
    );

    await mainDataResponse.fold(
      (failure) async => formJsonData = DynamicForm(
        name: '',
        form: [],
        dynamicAppbar: DynamicAppbarModel(),
      ),
      (responseData) async {
        formJsonData = responseData.isNotEmpty
            ? await DynamicForm.fromJson(responseData, true)
            : DynamicForm(
                name: '',
                form: [],
                dynamicAppbar: DynamicAppbarModel(),
              );
      },
    );

    return formJsonData;
  }

  Future<DynamicForm> getModuleData({
    required Map<String, dynamic> query,
    required String appName,
    required String moduleName,
    required int limit,
  }) async {
    DynamicForm formJsonData = DynamicForm(
      name: '',
      form: [],
      dynamicAppbar: DynamicAppbarModel(),
    );

    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.getModuleData(
      appName: appName,
      moduleName: moduleName,
      query: query,
      projection: {},
      limit: limit,
    );

    await mainDataResponse.fold(
      (failure) async => formJsonData = DynamicForm(
        name: '',
        form: [],
        dynamicAppbar: DynamicAppbarModel(),
      ),
      (responseData) async {
        formJsonData = responseData.isNotEmpty
            ? await DynamicForm.fromJson(responseData, true)
            : DynamicForm(
                name: '',
                form: [],
                dynamicAppbar: DynamicAppbarModel(),
              );
        await SharedPrefs()
            .setString(formJsonData.name, jsonEncode(responseData));
        pageName = formJsonData.name;
      },
    );

    return formJsonData;
  }

  // Future<DynamicData> getLookUpsModuleData({
  //   required Map<String, dynamic> query,
  //   required String appName,
  //   required String moduleName,
  //   required int limit,
  //   required List<dynamic> lookUps,
  // }) async {
  //   DynamicData formJsonData = DynamicData(dynamicData: []);

  //   Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
  //       await _repo.getModuleLookupsData(
  //     appName: appName,
  //     moduleName: moduleName,
  //     query: query,
  //     projection: {},
  //     limit: limit,
  //     lookUps: lookUps,
  //   );

  //   print("mainResponse$mainDataResponse");

  //   await mainDataResponse.fold(
  //     (failure) async => formJsonData = DynamicData(dynamicData: []),
  //     (responseData) async {
  //       formJsonData = responseData.isNotEmpty
  //           ? DynamicData.fromJson(responseData)
  //           : DynamicData(dynamicData: []);
  //       await SharedPrefs()
  //           .setString("${pageName}query", jsonEncode(responseData));
  //     },
  //   );

  //   return formJsonData;
  // }

  Future<DynamicData> getDynamicLookUpsModuleData({
    required String? url,
    String? index,
    required Map<String, dynamic>? body,
    required Map<String, dynamic>? headers,
    required Map<String, String>? saveToLocal,
    required List<String>? clearFromLocal,
  }) async {
    // Default initialization
    DynamicData formJsonData = DynamicData(dynamicData: {});
    Either<ApiFailure, dynamic> mainDataResponse =
        await _repo.getModuleLookupsData(
      body: body,
      headers: headers,
      url: url,
    );

    print("Main Response: $mainDataResponse");

    await mainDataResponse.fold(
      (failure) async {
        // Handle failure
        print("API Failure: $failure");
        formJsonData = DynamicData(dynamicData: {});
      },
      (responseData) async {
        if (responseData is Map<String, dynamic>) {
          // If the response is a Map
          formJsonData = DynamicData.fromJson(responseData);
          await SharedPrefs()
              .setString("${pageName}query", jsonEncode(responseData));
        } else if (responseData is List<dynamic>) {
          // If the response is a List, convert it into a Map with index keys
          Map<String, dynamic> convertedData = {
            // for (int i = 0; i < responseData.length; i++) '$i': responseData[i]
            index != null ? "data$index" : "data": responseData
          };
          formJsonData = DynamicData(dynamicData: convertedData);
          await SharedPrefs()
              .setString("${pageName}query", jsonEncode(convertedData));
        } else {
          // Unexpected data type
          print("Unexpected response type: ${responseData.runtimeType}");
          formJsonData = DynamicData(dynamicData: {});
        }

        if (clearFromLocal != null) {
          if (clearFromLocal.isNotEmpty) {
            await _clearDataFromLocal(clearFromLocal);
          }
        }

        if (saveToLocal != null) {
          final saveToLocalKeys = saveToLocal;
          Map<String, dynamic> dynamicDataKeyValue =
              convertDynamicDataToKeyValue(formJsonData.dynamicData);
          await _handleSaveToLocalKeys(saveToLocalKeys, dynamicDataKeyValue);
        }
      },
    );

    return formJsonData;
  }

  Map<String, dynamic> convertDynamicDataToKeyValue(dynamic dynamicData) {
    Map<String, dynamic> keyValueMap = {};

    // Handle DynamicData type explicitly
    if (dynamicData is DynamicData) {
      dynamicData = dynamicData.dynamicData; // Extract the raw dynamicData list
    }

    // Function to process nested maps or lists recursively
    void processNested(dynamic data, [String? parentKey]) {
      if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          final newKey = parentKey != null ? '$parentKey.$key' : key;
          if (value is Map || value is List) {
            keyValueMap[newKey.toString()] = value;
            processNested(value, newKey);
          } else {
            keyValueMap[newKey.toString()] = value;
          }
        });
      } else if (data is List) {
        for (var i = 0; i < data.length; i++) {
          final newKey = parentKey != null ? '$parentKey[$i]' : '[$i]';
          processNested(data[i], newKey);
        }
      } else {
        // If the data is not a Map or List, add it directly
        if (parentKey != null) {
          keyValueMap[parentKey.toString()] = data;
        }
      }
    }

    // Start processing the input data
    processNested(dynamicData);
    return keyValueMap;
  }

  Future<void> _clearDataFromLocal(List<String>? clearFromLocal) async {
    if (clearFromLocal == null || clearFromLocal.isEmpty) return;

    for (String key in clearFromLocal) {
      if (key.isNotEmpty) {
        await SharedPrefs().remove(key);
        print("Cleared data for key: $key");
      }
    }
  }

  Future<void> _handleSaveToLocalKeys(
    Map<String, String> saveToLocalKeys,
    Map<String, dynamic> formJsonData,
  ) async {
    saveToLocalKeys.forEach((localKey, formJsonKey) async {
      if (localKey.isNotEmpty && formJsonKey.isNotEmpty) {
        final dynamic value = _findNestedValue(formJsonData, formJsonKey);

        if (value != null) {
          await _saveToLocal(localKey, value);
        } else {
          print("Value not found for formJsonKey: $formJsonKey");
        }
      } else {
        print("Invalid saveToLocal entry: ${"$localKey,$formJsonKey"}");
      }
    });
  }

  dynamic _findNestedValue(Map<String, dynamic> map, String key) {
    if (map.containsKey(key)) {
      return map[key];
    }

    for (var entry in map.entries) {
      if (entry.value is Map<String, dynamic>) {
        final nestedValue =
            _findNestedValue(entry.value as Map<String, dynamic>, key);
        if (nestedValue != null) {
          return nestedValue;
        }
      }
    }

    return null; // Return null if the key is not found
  }

// Helper function to save to local storage
  Future<void> _saveToLocal(String key, dynamic value) async {
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
    print("Saved Data for localStorage ${prefs.getKeys()}");
    // Debug print for verification
    print("Saved value for localStorage $key: ${prefs.get(key)}");
  }

  Future<void> submitForm(Map<String, dynamic> formData) async {
    try {
      print('Submitting form with data: ${jsonEncode(formData)}');
    } catch (e) {
      throw Exception('Form submission failed');
    }
  }

  Future<void> uploadFile(String filePath) async {
    try {
      print('Uploading file: $filePath');
    } catch (e) {
      throw Exception('File upload failed');
    }
  }
}

const formJson = """{
   "status":true,
   "message":"Success",
   "title":"home",
   "appbar":{
      "title":"appBar"
   },
   "form":[
      {
         "section":{
            "fields":[
               {
                  "label":"Hello List 23355",
                  "type":"text"
               },
               {
                  "label":"Profile Image",
                  "type":"image",
                  "style":{
                     "imgurl":"https://i0.wp.com/picjumbo.com/wp-content/uploads/breathtaking-bali-nature-free-photo.jpg?w=600&quality=80",
                     "placeholder":"Upload your profile image",
                     "borderWidth":1,
                     "height":80,
                     "width":100,
                     "borderRadius":5,
                     "paddingVertical":10,
                     "paddingHorizontal":15,
                     "borderColor":"gray"
                  }
               },
               {
                  "type":"column",
                  "name":"row",
                  "items":[
                     {
                        "label":"Hello List column",
                        "type":"text"
                     },
                     {
                        "label":"Hello List column",
                        "type":"text"
                     }
                  ]
               },
               {
                  "label":"list",
                  "type":"list",
                  "scrollDirection":"vertical",
                  "items":[
                     {
                        "type":"column",
                        "items":[
                           {
                              "label":"Hello List 12345",
                              "type":"text"
                           },
                           {
                              "label":"Profile Image",
                              "type":"image",
                              "style":{
                                 "imgurl":"https://i0.wp.com/picjumbo.com/wp-content/uploads/breathtaking-bali-nature-free-photo.jpg?w=600&quality=80",
                                 "placeholder":"Upload your profile image",
                                 "borderWidth":1,
                                 "height":80,
                                 "width":100,
                                 "borderRadius":5,
                                 "paddingVertical":10,
                                 "paddingHorizontal":15,
                                 "borderColor":"gray"
                              }
                           }
                        ]
                     },
                     {
                        "label":"Hello List 123456789",
                        "type":"text"
                     }
                  ]
               },
               {
                  "type":"container",
                  "width":100.0,
                  "height":100.0,
                  "radius":10.0,
                  "margin":{
                     "left":5.0,
                     "right":10.0,
                     "top":15.0,
                     "bottom":20.0
                  },
                  "padding":{
                     "left":5.0,
                     "right":10.0,
                     "top":15.0,
                     "bottom":20.0
                  },
                  "backGroundColor":"#42A5F5",
                  "borderColor":"#000000",
                  "showBorder":true,
                  "items":[
                     {
                        "label":"Hello List contain",
                        "type":"text"
                     }
                  ]
               }
            ]
         }
      }
   ]
}""";
// const formJson = """{
//    "status":true,
//    "message":"Success",
//    "title":"home",
//    "appbar":{
//       "title":"appBar"
//    },
//    "form":[
//       {
//          "section":{
//             "fields":[
//                {
//                   "type":"row",
//                   "name":"row",
//                   "items":[
//                      {
//                         "label":"Hello List 23355",
//                         "type":"text"
//                      },
//                      {
//                         "label":"Hello List 23355",
//                         "type":"text"
//                      }
//                   ]
//                },
//                {
//                   "type":"container",
//                   "width":100.0,
//                   "height":100.0,
//                   "radius":10.0,
//                   "margin":{
//                      "left":5,
//                      "right":10,
//                      "top":15,
//                      "bottom":20
//                   },
//                   "padding":{
//                      "left":5,
//                      "right":10,
//                      "top":15,
//                      "bottom":20
//                   },
//                   "backGroundColor":"#42A5F5",
//                   "borderColor":"#000000",
//                   "showBorder":true,
//                   "items":[
//                      {
//                         "label":"Hello List contain",
//                         "type":"text"
//                      }
//                   ]
//                },
              //  {
              //     "label":"Profile Image",
              //     "type":"image",
              //     "style":{
              //        "imgurl":"https://i0.wp.com/picjumbo.com/wp-content/uploads/breathtaking-bali-nature-free-photo.jpg?w=600&quality=80",
              //        "placeholder":"Upload your profile image",
              //        "borderWidth":1,
              //        "height":80,
              //        "width":100,
              //        "borderRadius":5,
              //        "paddingVertical":10,
              //        "paddingHorizontal":15,
              //        "borderColor":"gray"
              //     }
              //  },
//                {
//                   "label":"Hello List 23355",
//                   "type":"text"
//                },
              //  {
              //     "label":"list",
              //     "type":"list",
              //     "scrollDirection":"verticle",
              //     "items":[
              //        {
              //           "type":"column",
              //           "items":[
              //              {
              //                 "label":"Hello List 23355",
              //                 "type":"text"
              //              },
              //              {
              //                 "label":"Profile Image",
              //                 "type":"image",
              //                 "style":{
              //                    "imgurl":"https://i0.wp.com/picjumbo.com/wp-content/uploads/breathtaking-bali-nature-free-photo.jpg?w=600&quality=80",
              //                    "placeholder":"Upload your profile image",
              //                    "borderWidth":1,
              //                    "height":80,
              //                    "width":100,
              //                    "borderRadius":5,
              //                    "paddingVertical":10,
              //                    "paddingHorizontal":15,
              //                    "borderColor":"gray"
              //                 }
              //              }
              //           ]
              //        },
              //        {
              //           "label":"Hello List 23355",
              //           "type":"text"
              //        }
              //     ]
              //  },
//                {
//                   "label":"Hello List 23355",
//                   "type":"text"
//                }
//             ]
//          }
//       }
//    ]
// }""";
