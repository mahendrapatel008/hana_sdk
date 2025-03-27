
import 'package:dartz/dartz.dart';
import 'package:hana_sdk/configs/api_config.dart';
import 'package:hana_sdk/di/di.dart';
import 'package:hana_sdk/errors/error_handler_new.dart';
import 'package:hana_sdk/network/api_result_handler.dart';
import 'package:hana_sdk/network/api_service.dart';

class AuthRepo {

  Future<Either<ApiFailure, bool>> emailVerification({
    required String email,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> data = {
        "email": email,
        "otp": otp
      };
      Either<ApiFailure, ApiSuccess> emailVerificationResponse =
          await sl<ApiService>().post(
        url: ApiConfig.verifyUserEndpoint,
        data: data,
      );

      return emailVerificationResponse.fold(
        (failure) {
          return Left(failure);
        },
        (success) {
          return Right(success.response.data["success"] ?? false);
        },
      );
    } catch (e) {
      throw Left(ErrorHandler.handle(e).failure);
    }
  }
}
