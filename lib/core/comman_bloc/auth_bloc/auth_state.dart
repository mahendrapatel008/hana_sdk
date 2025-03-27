
import 'package:hana_sdk/core/model/on_click_data.dart';

abstract class AuthBlocState {
  const AuthBlocState();
}

class AuthBlocStateInitial extends AuthBlocState {}

class AuthBlocStateLoading extends AuthBlocState {}

class AuthBlocStateTokenSuccess extends AuthBlocState {}

class AuthBlocStateLogoutSuccess extends AuthBlocState {}

class AuthBlocStateRegisterSuccess extends AuthBlocState {
  final String? pageName;

  AuthBlocStateRegisterSuccess({required this.pageName});
}

class AuthBlocStateRegisterWithOtpSuccess extends AuthBlocState {}

class AuthBlocStateLoginSuccess extends AuthBlocState {
  final String? pageName;

  AuthBlocStateLoginSuccess({required this.pageName});
}

class AuthBlocStateLoginWithOtpSuccess extends AuthBlocState {}

class AuthBlocStateOtpVerified extends AuthBlocState {
  final String pageName;

  AuthBlocStateOtpVerified({required this.pageName});
}

class AuthBlocStateEmailVerified extends AuthBlocState {}

class AuthBlocStateEmailNotVerified extends AuthBlocState {}

class AuthBlocStateEmailNotFound extends AuthBlocState {}

class AuthBlocStateDataRefresh extends AuthBlocState {
  final Map<String, dynamic>? mapData;
  final Map<String, String>? saveToLocal;
  final List<String>? clearFromLocal;
  final String? url;
  final Map<String, dynamic>? headers;
  final String? serverError;
  final String? pageName;
  final OnClickData? onClickData;
  final bool? previousClear;

  AuthBlocStateDataRefresh(
      {required this.mapData,
      required this.saveToLocal,
      required this.clearFromLocal,
      required this.url,
      required this.headers,
      this.pageName,
      required this.serverError,
      this.onClickData,
      this.previousClear});
}

class AuthBlocStateRegisterFailure extends AuthBlocState {}

class AuthBlocStateCommonLogin extends AuthBlocState {
  final String message;
  final String pageName;
  final OnClickData? onClickData;

  AuthBlocStateCommonLogin(
      {required this.message,
      required this.pageName,
      required this.onClickData});
}

class AuthBlocStateuploadAndStore extends AuthBlocState {
  final String message;

  AuthBlocStateuploadAndStore({
    required this.message,
  });
}

class AuthBlocLocationFetcher extends AuthBlocState {
  final String message;

  AuthBlocLocationFetcher({
    required this.message,
  });
}

class AuthBlocStateCommonSubmitData extends AuthBlocState {
  final String message;
  final String pageName;
  final OnClickData? onClickData;

  AuthBlocStateCommonSubmitData({
    required this.message,
    required this.pageName,
    required this.onClickData,
  });
}

class AuthBlocStateCommonDeleteAccountData extends AuthBlocState {
  final String message;
  final String pageName;
  final OnClickData? onClickData;
  AuthBlocStateCommonDeleteAccountData({
    required this.message,
    required this.pageName,
    required this.onClickData,
  });
}

class AuthBlocStateRegisterError extends AuthBlocState {
  final String errorMessage;
  final String? serverError;

  AuthBlocStateRegisterError({
    required this.errorMessage,
    required this.serverError,
  });
}

class AuthBlocStateTokenError extends AuthBlocState {
  final String errorMessage;

  AuthBlocStateTokenError({required this.errorMessage});
}
