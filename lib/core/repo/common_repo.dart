import 'dart:developer' as log;
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hana_sdk/configs/api_config.dart';
import 'package:hana_sdk/core/model/upload_store_model.dart';
import 'package:hana_sdk/di/di.dart';
import 'package:hana_sdk/errors/error_handler_new.dart';
import 'package:hana_sdk/network/api_result_handler.dart';
import 'package:hana_sdk/network/api_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class CommonRepository {
  // final ApiConfig _apiConfig = ApiConfig();

  Future<Either<ApiFailure, dynamic>> addData({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: ApiConfig.addDataEndpoint,
        data: {
          "dbName": "banner",
          "collectionName": collectionName,
          "data": data,
        },
      );
      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(success.response.data),
      );
    } catch (e) {
      log.log("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> commaonApi({
    required Map<String, dynamic> data,
    required String url,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: url,
        data: data,
      );
      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(success.response.data),
      );
    } catch (e) {
      log.log("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> commaonDynamicApi({
    required Map<String, dynamic>? data,
    required String? url,
    required String? apiType,
    required Map<String, dynamic>? headers,
  }) async {
    if (apiType == "get") {
      try {
        Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().get(
          url: url ?? '',
          data: data,
          headers: headers ?? {},
        );
        return reqResponse.fold(
          (failure) => Left(failure),
          (success) => Right(success.response.data),
        );
      } catch (e) {
        log.log("error===>${e.toString()}");
        throw Left(ErrorHandler.handle(e).failure);
      }
    } else if (apiType == "delete") {
      try {
        Either<ApiFailure, ApiSuccess> reqResponse =
            await sl<ApiService>().delete(
          url: url ?? '',
          data: data,
          headers: headers ?? {},
        );
        return reqResponse.fold(
          (failure) => Left(failure),
          (success) => Right(success.response.data),
        );
      } catch (e) {
        log.log("error===>${e.toString()}");
        throw Left(ErrorHandler.handle(e).failure);
      }
    } else {
      try {
        Either<ApiFailure, ApiSuccess> reqResponse =
            await sl<ApiService>().post(
          url: url ?? '',
          data: data,
          headers: headers ?? {},
        );
        return reqResponse.fold(
          (failure) => Left(failure),
          (success) => Right(success.response.data),
        );
      } catch (e) {
        log.log("error===>${e.toString()}");
        throw Left(ErrorHandler.handle(e).failure);
      }
    }
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> commaonDeleteApi({
    required Map<String, dynamic> data,
    required String url,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse =
          await sl<ApiService>().delete(
        url: url,
        data: data,
      );
      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(success.response.data),
      );
    } catch (e) {
      log.log("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> getData({
    required String collectionName,
    required Map<String, dynamic> query,
    required Map<String, dynamic> projection,
    required int limit,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: ApiConfig.mfindEndpoint,
        data: {
          "dbName": "banner",
          "collectionName": collectionName,
          "query": query,
          "projection": projection,
          "limit": limit,
          "order": "descending"
        },
      );

      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(success.response.data),
      );
    } catch (e) {
      print("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, UploadAndStoreModel>> uploadStoreFile({
    required String? folderName,
    required String url,
    required String name,
    required String keyToStore,
    required File? filePath,
    required String? collectionName,
    required Map<String, dynamic>? headers,
  }) async {
    try {
      var formData = FormData();
      // formData.fields.add(MapEntry('folderName', folderName!));
      formData.files.add(
        MapEntry(
          keyToStore,
          await MultipartFile.fromFile(
            filePath!.path,
          ),
        ),
      );
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: url,
        data: formData,
        headers: headers,
      );

      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(UploadAndStoreModel.fromJson(success.response.data)),
      );
    } catch (e) {
      log.log("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> getModuleData({
    required String appName,
    required String moduleName,
    required Map<String, dynamic> query,
    required Map<String, dynamic> projection,
    required int limit,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: ApiConfig.domain + ApiConfig.dynamicData,
        data: {
          "appName": appName,
          "moduleName": moduleName,
          "query": query,
          "projection": projection,
          "limit": limit,
          "skip": 0,
          "order": "descending"
        },
      );

      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(success.response.data),
      );
    } catch (e) {
      print("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, dynamic>> getModuleLookupsData({
    required String? url,
    required Map<String, dynamic>? body,
    required Map<String, dynamic>? headers,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: url ?? '',
        data: body,
        headers: headers,
      );

      return reqResponse.fold(
        (failure) => Left(failure),
        (success) {
          print("API Response Data: ${success.response.data}");
          return Right(success.response.data);
        },
      );
    } catch (e) {
      print("Error in getModuleLookupsData: ${e.toString()}");
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> deleteData({
    required String collectionName,
    required Map<String, dynamic> query,
  }) async {
    try {
      Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
        url: ApiConfig.deleteDataEndpoint,
        data: {
          "dbName": "banner",
          "collectionName": collectionName,
          "query": query,
        },
      );
      return reqResponse.fold(
        (failure) => Left(failure),
        (success) => Right(success.response.data),
      );
    } catch (e) {
      log.log("error===>${e.toString()}");
      throw Left(ErrorHandler.handle(e).failure);
    }
  }

  // Future<Either<ApiFailure, UploadAndStoreModel>> uploadStoreFile({
  //   required String? folderName,
  //   required File? filePath,
  // }) async {
  //   try {
  //     var formData = FormData();
  //     formData.fields.add(MapEntry('folderName', folderName!));
  //     formData.files.add(
  //       MapEntry(
  //         'file',
  //         await MultipartFile.fromFile(
  //           filePath!.path,
  //         ),
  //       ),
  //     );
  //     Either<ApiFailure, ApiSuccess> reqResponse = await sl<ApiService>().post(
  //       url: _apiConfig.uploadStoreEndpoint,
  //       data: formData,
  //     );

  //     return reqResponse.fold(
  //       (failure) => Left(failure),
  //       (success) => Right(UploadAndStoreModel.fromJson(success.response.data)),
  //     );
  //   } catch (e) {
  //     log.log("error===>${e.toString()}");
  //     throw Left(ErrorHandler.handle(e).failure);
  //   }
  // }

  static Future<void> sendTopicNotificationv2(Map<String, dynamic> mainData,
      String topic, String title, String body) async {
    // Load the service account key
    final serviceAccountKey =
        await rootBundle.loadString('assets/data/data_json.json');
    final credentials =
        ServiceAccountCredentials.fromJson(json.decode(serviceAccountKey));

    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    // Get an authenticated HTTP client
    final client = await clientViaServiceAccount(credentials, scopes);

    final accessToken = (client.credentials).accessToken.data;

    print("AccessToken: $accessToken");

    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
    };
    // final Map<String, dynamic> android = {
    //   "notification": {"click_action": "VISITOR_ENTRY_ACTIVITY"}
    // };
    final Map<String, dynamic> android = {"priority": "HIGH"};
    Map<String, dynamic> message = {};
    if (topic.toLowerCase().contains('topic')) {
      message = {
        'topic': topic,
        'notification': notification,
        'data': mainData,
        'android': android,
      };
    } else {
      message = {
        'token': topic,
        'notification': notification,
        'data': mainData,
        'android': android,
      };
    }

    const String url =
        'https://fcm.googleapis.com/v1/projects/commune-app-29939/messages:send';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      print('Notification??? sent successfully');
    } else {
      print(
          'Notification??? ailed to send notification: ${response.statusCode}');
      print('Notification??? ailed to send notification: ${response.body}');
      print(
          'Notification??? ailed to send notification: ${response.request.toString()}');
      print('Notification??? Response: ${response.body}');
    }

    client.close();
  }
}
