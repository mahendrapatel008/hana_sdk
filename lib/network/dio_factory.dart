// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  // final SharedPrefs _appPreferences;

  // DioFactory(this._appPreferences);

  Future<Dio> getDio([Map<String, String>? headers]) async {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true)); // Log responses

    // String language = await _appPreferences.getAppLanguage();
    Map<String, String> defaultHeaders = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      // AUTHORIZATION: Constants.token,
      DEFAULT_LANGUAGE: "en"
    };

    dio.options = BaseOptions(
      // baseUrl: Constants.baseUrl,
      headers: headers ?? defaultHeaders,
      // receiveTimeout: Constants.apiTimeOut,
      // sendTimeout: Constants.apiTimeOut,
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    // if (!kReleaseMode) {
    //   dio.interceptors.add(dioLoggerInterceptor);
    // }

    return dio;
  }
}
