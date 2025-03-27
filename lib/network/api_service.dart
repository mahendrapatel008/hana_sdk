import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/errors/error_handler_new.dart';

import 'api_result_handler.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Either<ApiFailure, ApiSuccess>> get({
    required String url,
    Object? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.get(
          url,
          data: data,
          queryParameters: params,
          options: Options(
            headers: headers,
          ),
        ));
  }

  Future<Either<ApiFailure, ApiSuccess>> post({
    required String url,
    Object? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.post(
          url,
          data: data,
          queryParameters: params,
          options: Options(
            headers: headers,
          ),
        ));
  }

  Future<Either<ApiFailure, ApiSuccess>> put({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
  }) async {
    return _executeRequest(() => _dio.put(
          url,
          data: data,
          queryParameters: params,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPrefs().accessToken}',
              'Content-Type': 'application/json',
            },
          ),
        ));
  }

  Future<Either<ApiFailure, ApiSuccess>> delete({
    required String url,
    Object? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.delete(
          url,
          data: data,
          queryParameters: params,
          options: Options(
            headers: headers,
          ),
        ));
  }

  Future<Either<ApiFailure, ApiSuccess>> otpVerify({
    required String url,
    Object? data,
    Map<String, dynamic>? params,
  }) async {
    return _executeRequest(() => _dio.post(
          url,
          data: data,
          queryParameters: params,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPrefs().accessToken}',
              'Content-Type': 'application/json',
            },
          ),
        ));
  }

  Future<Either<ApiFailure, ApiSuccess>> _executeRequest(
      Future<Response> Function() request) async {
    try {
      final response = await request();
      _logResponseDetails(response);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.accepted ||
          response.statusCode == HttpStatus.created) {
        return Right(ApiSuccess(response, response.statusCode));
      } else {
        return Left(ApiFailure(
            message: 'HTTP Error: ${response.data['message']}',
            statusCode: response.statusCode));
      }
    } on SocketException {
      return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
    } on FormatException {
      return Left(DataSource.FORMAT_ERROR.getFailure());
    } on DioException catch (error) {
      return Left(_handleDioError(error));
    } on FirebaseAuthException catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    } catch (error) {
      return Left(
          ApiFailure(message: 'Unexpected Error: $error', statusCode: 400));
    }
  }

  void _logResponseDetails(Response response) {
    debugPrint('HTTP Response:');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Headers: ${response.headers}');
    debugPrint('Body: ${response.data}');
  }

  ApiFailure _handleDioError(DioException error) {
    if (error.response != null) {
      return ApiFailure(
          message: '${error.response?.data['message']}',
          statusCode: error.response?.statusCode);
    } else {
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    }
  }
}


// class ApiServiceNew {
//   final Dio _dio;
//   ApiServiceNew(this._dio);

//   Future<Either<ApiFailure, ApiSuccess>> get({
//     required String url,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//   }) async {
//     try {
//       Response response = await _dio.get(
//         url,
//         data: data,
//         queryParameters: params,
//       );
//       debugPrint(response.statusCode.toString());
//       debugPrint('base:    ${_dio.options.baseUrl}');
//       debugPrint('url:    $url');
//       debugPrint('header:    ${_dio.options.headers}');
//       debugPrint('queryParameters:    $data');
//       debugPrint('response:    $response');
//       debugPrint('response.data:    ${response.data}');
//       return Right(ApiSuccess(response, response.statusCode));
//     } on SocketException {
//       return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
//     } on FormatException {
//       return Left(DataSource.FORMAT_ERROR.getFailure());
//     } on DioException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     } on FirebaseAuthException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     }
//   }

//   Future<Either<ApiFailure, ApiSuccess>> post({
//     required String url,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//   }) async {
//     try {
//       Response response = await _dio.post(
//         url,
//         data: data,
//         queryParameters: params,
//         options: Options(
//           headers: {
//             "Authorization": await ApiConfig().bearerToken,
//             'Content-Type': 'application/json',
//           },
//         ),
//       );
//       debugPrint(response.statusCode.toString());
//       debugPrint('base:    ${_dio.options.baseUrl}');
//       debugPrint('url:    $url');
//       debugPrint('header:    ${_dio.options.headers}');
//       debugPrint('queryParameters:    $data');
//       debugPrint('response:    $response');
//       return Right(ApiSuccess(response, response.statusCode));
//     } on SocketException {
//       return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
//     } on FormatException {
//       return Left(DataSource.FORMAT_ERROR.getFailure());
//     } on DioException catch (error) {
//       if (error.response?.statusCode == 403) {
//         // Util.showRedToast(error.response!.data['message']);
//         return Left(DataSource.FORBIDDEN.getFailure());
//       }
//       return Left(ErrorHandler.handle(error).failure);
//     } on FirebaseAuthException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     }
//   }

//   Future<Either<ApiFailure, ApiSuccess>> put({
//     required String url,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//   }) async {
//     try {
//       Response response = await _dio.put(
//         url,
//         data: data,
//         queryParameters: params,
//       );
//       debugPrint(response.statusCode.toString());
//       debugPrint('base:    ${_dio.options.baseUrl}');
//       debugPrint('url:    $url');
//       debugPrint('header:    ${_dio.options.headers}');
//       debugPrint('queryParameters:    $response');
//       debugPrint('response:    $response');
//       return Right(ApiSuccess(response.data, response.statusCode));
//     } on SocketException {
//       return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
//     } on FormatException {
//       return Left(DataSource.FORMAT_ERROR.getFailure());
//     } on DioException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     } on FirebaseAuthException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     }
//   }

//   Future<Either<ApiFailure, ApiSuccess>> delete({
//     required String url,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//   }) async {
//     try {
//       Response response = await _dio.delete(
//         url,
//         data: data,
//         queryParameters: params,
//       );
//       debugPrint(response.statusCode.toString());
//       debugPrint('base:    ${_dio.options.baseUrl}');
//       debugPrint('url:    $url');
//       debugPrint('header:    ${_dio.options.headers}');
//       debugPrint('queryParameters:    $response');
//       debugPrint('response:    $response');
//       return Right(ApiSuccess(response.data, response.statusCode));
//     } on SocketException {
//       return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
//     } on FormatException {
//       return Left(DataSource.FORMAT_ERROR.getFailure());
//     } on DioException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     } on FirebaseAuthException catch (error) {
//       return Left(ErrorHandler.handle(error).failure);
//     }
//   }
// }
