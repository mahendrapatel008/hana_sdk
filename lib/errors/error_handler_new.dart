import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hana_sdk/core/utils/string.dart';
import 'package:hana_sdk/network/api_result_handler.dart';
class ErrorHandler implements Exception {
  late ApiFailure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else if (error is PlatformException) {
      String errorMessage;

      switch (error.code) {
        case "NETWORK_ERROR":
          errorMessage =
              "Failed to connect to the server. Please check your internet connection and try again.";
          break;
        case "PERMISSION_DENIED":
          errorMessage =
              "Permission denied. Please grant the required permission and try again.";
          break;
        case "AUTH_ERROR":
          errorMessage =
              "Authentication failed. Please check your credentials and try again.";
          break;
        case "NOT_FOUND":
          errorMessage = "Resource not found.";
          break;
        case "INVALID_ARGUMENT":
          errorMessage = "Invalid argument provided.";
          break;
        case "TIMEOUT":
          errorMessage = "The operation timed out. Please try again later.";
          break;
        default:
          errorMessage = "An error occurred: ${error.message}";
      }
      failure = ApiFailure(statusCode: 400, message: errorMessage);
    }
    if (error is FirebaseAuthException) {
      failure = _handleFirebaseError(error);
    } else {
      // default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

ApiFailure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return ApiFailure(
            statusCode: error.response?.statusCode ?? 0,
            message: error.response?.data["message"] ?? "Bad response");
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

ApiFailure _handleFirebaseError(FirebaseAuthException error) {
  switch (error.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return DataSource.EMAIL_IN_USE.getFailure();
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return DataSource.WRONG_PASSWORD.getFailure();
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return DataSource.ERROR_USER_NOT_FOUND.getFailure();
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return DataSource.ERROR_USER_NOT_FOUND.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  FORMAT_ERROR,
  EMAIL_IN_USE,
  WRONG_PASSWORD,
  ERROR_USER_NOT_FOUND,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  ApiFailure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return ApiFailure(
          statusCode: ResponseCode.SUCCESS,
          message: ResponseMessage.SUCCESS,
        );
      case DataSource.NO_CONTENT:
        return ApiFailure(
          statusCode: ResponseCode.NO_CONTENT,
          message: ResponseMessage.NO_CONTENT,
        );
      case DataSource.BAD_REQUEST:
        return ApiFailure(
          statusCode: ResponseCode.BAD_REQUEST,
          message: ResponseMessage.BAD_REQUEST,
        );
      case DataSource.FORBIDDEN:
        return ApiFailure(
          statusCode: ResponseCode.FORBIDDEN,
          message: ResponseMessage.FORBIDDEN,
        );
      case DataSource.UNAUTORISED:
        return ApiFailure(
          statusCode: ResponseCode.UNAUTORISED,
          message: ResponseMessage.UNAUTORISED,
        );
      case DataSource.NOT_FOUND:
        return ApiFailure(
          statusCode: ResponseCode.NOT_FOUND,
          message: ResponseMessage.NOT_FOUND,
        );
      case DataSource.INTERNAL_SERVER_ERROR:
        return ApiFailure(
          statusCode: ResponseCode.INTERNAL_SERVER_ERROR,
          message: ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return ApiFailure(
          statusCode: ResponseCode.CONNECT_TIMEOUT,
          message: ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return ApiFailure(
          statusCode: ResponseCode.CANCEL,
          message: ResponseMessage.CANCEL,
        );
      case DataSource.RECIEVE_TIMEOUT:
        return ApiFailure(
          statusCode: ResponseCode.RECIEVE_TIMEOUT,
          message: ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return ApiFailure(
          statusCode: ResponseCode.SEND_TIMEOUT,
          message: ResponseMessage.SEND_TIMEOUT,
        );
      case DataSource.CACHE_ERROR:
        return ApiFailure(
          statusCode: ResponseCode.CACHE_ERROR,
          message: ResponseMessage.CACHE_ERROR,
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiFailure(
          statusCode: ResponseCode.NO_INTERNET_CONNECTION,
          message: ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.FORMAT_ERROR:
        return ApiFailure(
          statusCode: ResponseCode.CANCEL,
          message: ResponseMessage.CANCEL,
        );
      case DataSource.EMAIL_IN_USE:
        return ApiFailure(
            statusCode: ResponseCode.BAD_REQUEST,
            message: 'Email already,  used. Go to login page.');
      case DataSource.WRONG_PASSWORD:
        return ApiFailure(
            statusCode: ResponseCode.BAD_REQUEST,
            message: 'Wrong email, /password combination.');
      case DataSource.ERROR_USER_NOT_FOUND:
        return ApiFailure(
            statusCode: ResponseCode.BAD_REQUEST,
            message: 'No user,  found with this email.');
      case DataSource.DEFAULT:
        return ApiFailure(
          statusCode: ResponseCode.DEFAULT,
          message: ResponseMessage.DEFAULT,
        );
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = Strings.success; // success with data
  static const String NO_CONTENT =
      Strings.success; // success with no data (no content)
  static const String BAD_REQUEST =
      Strings.strBadRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      Strings.strUnauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      Strings.strForbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      Strings.strInternalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      Strings.strNotFoundError; // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = Strings.strTimeoutError;
  static const String CANCEL = Strings.strDefaultError;
  static const String RECIEVE_TIMEOUT = Strings.strTimeoutError;
  static const String SEND_TIMEOUT = Strings.strTimeoutError;
  static const String CACHE_ERROR = Strings.strCacheError;
  static const String NO_INTERNET_CONNECTION = Strings.strNoInternetError;
  static const String DEFAULT = Strings.strDefaultError;
}

class ApiInternalStatus {
  static const int SUCCESS = 200;
  static const int FAILURE = 400;
}
