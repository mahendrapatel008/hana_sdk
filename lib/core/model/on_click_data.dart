import 'dart:convert';

import 'package:hana_sdk/core/elements/dynamic_bottom_navbar/dynamic_bottom_navbar_model.dart';
import 'package:hana_sdk/core/elements/dynamic_popup/dynamic_popup_model.dart';
import 'package:hana_sdk/core/elements/dynamic_sidebar/dynamic_sidebar_model.dart';
import 'package:hana_sdk/core/model/external_api_call_model.dart';
import 'package:hana_sdk/core/model/image_picker_model.dart';

class OnClickData {
  final String? id;
  final String? pageName;
  final String? apiName;
  final String? serverError;
  final bool? isBack;
  final bool? share;
  final bool? isForm;
  final bool? withCameraImage;
  final bool? wantPreviousData;
  final bool? reUseData;
  final bool? isOtherRemove;
  final bool? isSelectedRemove;
  final bool? pageReplacement;
  final bool? hanaDependentRemoval;
  final String? pageType;
  final String? locationDatabase;
  final String? popCount;
  final String? collectionToSubmit;
  final String? sectionName;
  final int? pageIndex;
  final DynamicPopupModel? popupData;
  final List<ExternalApiCallModel>? apiCallData;
  final ImagePickerModel? imagePickerData;
  final List<dynamic>? query;
  final bool? isPreviousQueryClear;
  final DynamicBottomNavModel? navBarData;
  final DynamicSidebarModel? sideNavBarData;

  OnClickData({
    this.id,
    this.pageName,
    this.serverError,
    this.apiName,
    this.isBack,
    this.share,
    this.isForm,
    this.pageType,
    this.popCount,
    this.collectionToSubmit,
    this.sectionName,
    this.query,
    this.isPreviousQueryClear,
    this.popupData,
    this.apiCallData,
    this.imagePickerData,
    this.navBarData,
    this.sideNavBarData,
    this.wantPreviousData,
    this.withCameraImage,
    this.hanaDependentRemoval,
    this.pageIndex,
    this.reUseData,
    this.locationDatabase,
    this.isOtherRemove,
    this.isSelectedRemove,
    this.pageReplacement,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageName': pageName,
      'serverError': serverError,
      'isBack': isBack,
      'share': share,
      'isForm': isForm,
      'wantPreviousData': wantPreviousData,
      'apiName': apiCallData,
      'imagePickerData': imagePickerData,
      'popupData': popupData,
      'withCameraImage': withCameraImage,
      'reUseData': reUseData,
      'isOtherRemove': isOtherRemove,
      'isSelectedRemove': isSelectedRemove,
      'pageReplacement': pageReplacement,
      'hanaDependentRemoval': hanaDependentRemoval,
      'pageType': pageType,
      'locationDatabase': locationDatabase,
      'popCount': popCount,
      'collectionToSubmit': collectionToSubmit,
      'sectionName': sectionName,
      'pageIndex': pageIndex,
      'isPreviousQueryClear': isPreviousQueryClear,
      'query': query,
      'navBarData': navBarData?.toJson(),
      'sideNavBarData': sideNavBarData?.toJson(),
    };
  }

  factory OnClickData.fromJson(Map<String, dynamic> json) {
    DynamicPopupModel? popupDataJson;
    if (json['popupData'] is Map<String, dynamic>) {
      popupDataJson = DynamicPopupModel.fromJson(json['popupData']);
    } else {
      popupDataJson = null;
    }
    DynamicBottomNavModel? parsedNavBarData;
    if (json['navBarData'] is Map<String, dynamic>) {
      parsedNavBarData = DynamicBottomNavModel.fromJson(json['navBarData']);
    } else {
      parsedNavBarData = null;
    }

    DynamicSidebarModel? parsedSideNavBarData;
    if (json['sideNavBarData'] is Map<String, dynamic>) {
      parsedSideNavBarData =
          DynamicSidebarModel.fromJson(json['sideNavBarData']);
    } else {
      parsedSideNavBarData = null;
    }
    List<ExternalApiCallModel>? apiCallDatas;

    if (json['apiName'] is String) {
      try {
        final decoded = jsonDecode(json['apiName']);
        if (decoded is Map<String, dynamic>) {
          apiCallDatas = [ExternalApiCallModel.fromJson(decoded)];
        } else if (decoded is List) {
          apiCallDatas = decoded
              .map((item) =>
                  ExternalApiCallModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        print("Error decoding JSON string: $e");
        apiCallDatas = null;
      }
    } else if (json['apiName'] is Map<String, dynamic>) {
      apiCallDatas = [ExternalApiCallModel.fromJson(json['apiName'])];
    } else if (json['apiName'] is List) {
      apiCallDatas = (json['apiName'] as List)
          .map((item) =>
              ExternalApiCallModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      apiCallDatas = null;
    }
    ImagePickerModel? imagePickerDatas;
    if (json['imagePickerData'] is Map<String, dynamic>) {
      imagePickerDatas = ImagePickerModel.fromJson(json['imagePickerData']);
    } else {
      imagePickerDatas = null;
    }

    List<dynamic> jsonLookupData;

    // Check the type of json['query']
    if (json['query'] is String) {
      // If it's a string, decode it
      String jsonLookups = json['query'] ?? "[]";
      try {
        jsonLookupData = jsonDecode(jsonLookups) as List<dynamic>;
      } catch (e) {
        jsonLookupData = []; // Default to empty list if parsing fails
      }
    } else if (json['query'] is List<dynamic>) {
      // If it's already a list, use it directly
      jsonLookupData = json['query'] as List<dynamic>;
    } else {
      jsonLookupData = []; // Default to empty list if it's neither
    }

    return OnClickData(
      id: json['id'],
      pageName: json['pageName'],
      apiName: json['apiName11'],
      serverError: json['serverError'],
      isBack: json['isBack'],
      share: json['share'],
      isForm: json['isForm'],
      hanaDependentRemoval: json["hanaDependentRemoval"],
      wantPreviousData: json["wantPreviousData"],
      withCameraImage: json["withCameraImage"],
      reUseData: json["reUseData"],
      isOtherRemove: json["isOtherRemove"],
      locationDatabase: json["locationDatabase"],
      apiCallData: apiCallDatas,
      imagePickerData: imagePickerDatas,
      popupData: popupDataJson,
      isSelectedRemove: json["isSelectedRemove"],
      pageType: json['pageType'],
      popCount: json['popCount'],
      collectionToSubmit: json['collectionToSubmit'],
      sectionName: json['sectionName'],
      isPreviousQueryClear: json['isPreviousQueryClear'],
      pageReplacement: json['pageReplacement'],
      pageIndex: json['pageIndex'],
      query: jsonLookupData,
      navBarData: parsedNavBarData,
      sideNavBarData: parsedSideNavBarData,
    );
  }
}
