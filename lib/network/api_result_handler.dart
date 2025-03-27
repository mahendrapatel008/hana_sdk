import 'package:dio/dio.dart';

abstract class ApiResults {}

/// Represents a successful API response.
class ApiSuccess extends ApiResults {
  final Response response;
  final int? statusCode;

  /// Constructs an [ApiSuccess] object with the given [response] and [statusCode].
  ApiSuccess(this.response, this.statusCode);
}

/// Represents a failed API response.
class ApiFailure extends ApiResults {
  final int? statusCode;
  final String message;

  /// Constructs an [ApiFailure] object with the given error [statusCode] and [message].
  ApiFailure({required this.statusCode, required this.message});

  /// Factory constructor to create an [ApiFailure] from a DioError.
  factory ApiFailure.fromDioError(DioException error) {
    int errorCode = error.response?.statusCode ?? 0;
    String errorMessage = error.response?.statusMessage ?? "";
    return ApiFailure(statusCode: errorCode, message: errorMessage);
  }
}
