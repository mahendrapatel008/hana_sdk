import 'dart:io';

import 'package:hana_sdk/core/model/on_click_data.dart';

abstract class AuthBlocEvent {
  const AuthBlocEvent();
}

class AuthBlocCommonLoginEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  final String apiName;
  final String pageName;
  final String? serverError;
  final OnClickData? onClickData;
  const AuthBlocCommonLoginEvent({
    required this.mapData,
    required this.pageName,
    required this.apiName,
    required this.serverError,
    required this.onClickData,
  });
}

class AuthBlocDynamicCommonLoginEvent extends AuthBlocEvent {
  final String? url;
  final String? apiType;
  final Map<String, dynamic>? mapData;
  final Map<String, dynamic>? headers;
  final String? serverError;
  final String? pageName;
  final bool? isLast;
  final Map<String, String>? saveToLocal;
  final List<String>? clearFromLocal;
  final OnClickData? onClickData;
  const AuthBlocDynamicCommonLoginEvent({
    required this.url,
    required this.apiType,
    required this.mapData,
    required this.headers,
    this.pageName,
    this.isLast,
    required this.serverError,
    required this.saveToLocal,
    required this.clearFromLocal,
    this.onClickData,
  });
}

class AuthBlocCommonLocationFetcherEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocCommonLocationFetcherEvent({
    required this.mapData,
  });
}

class AuthBlocCommonSubmitEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  final String pageName;
  final String? serverError;
  final OnClickData? onClickData;
  const AuthBlocCommonSubmitEvent({
    required this.mapData,
    required this.pageName,
    required this.serverError,
    required this.onClickData,
  });
}

class AuthBlocCommonDeleteEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  final String pageName;
  final String? serverError;
  final OnClickData? onClickData;
  const AuthBlocCommonDeleteEvent({
    required this.mapData,
    required this.pageName,
    required this.serverError,
    required this.onClickData,
  });
}

class AuthBlocCommonAttendenceEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  final String? locationDatabase;
  final String pageName;
  final String? serverError;
  final OnClickData? onClickData;
  const AuthBlocCommonAttendenceEvent({
    required this.mapData,
    required this.pageName,
    this.locationDatabase,
    required this.serverError,
    required this.onClickData,
  });
}

class AuthBlocLoginEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocLoginEvent({
    required this.mapData,
  });
}

class AuthBlocDataRefresh extends AuthBlocEvent {
  final String? url;
  final Map<String, String>? saveToLocal;
  final List<String>? clearFromLocal;
  final bool? previousClear;
  final Map<String, dynamic>? mapData;
  final Map<String, dynamic>? headers;
  final String? serverError;
  final String? pageName;
  final OnClickData? onClickData;
  const AuthBlocDataRefresh({
    required this.url,
    required this.saveToLocal,
    required this.clearFromLocal,
    this.previousClear,
    required this.mapData,
    required this.headers,
    this.pageName,
    required this.serverError,
    this.onClickData,
  });
}

class AuthBlocLoginWithOtpEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocLoginWithOtpEvent({
    required this.mapData,
  });
}

class AuthBlocRegisterWithOtpEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocRegisterWithOtpEvent({
    required this.mapData,
  });
}

class AuthBlocVerifyOtpEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocVerifyOtpEvent({
    required this.mapData,
  });
}

class AuthBlocRegisterEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocRegisterEvent({
    required this.mapData,
  });
}

class AuthBlocRefreshTokenEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  const AuthBlocRefreshTokenEvent({
    required this.mapData,
  });
}

class AuthBlocLogoutEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  final String? serverError;
  const AuthBlocLogoutEvent({
    required this.mapData,
    required this.serverError,
  });
}

class AuthBlocGoogleLoginEvent extends AuthBlocEvent {
  final Map<String, dynamic> mapData;
  final String? pageName;
  final String? serverError;
  const AuthBlocGoogleLoginEvent({
    required this.mapData,
    required this.pageName,
    required this.serverError,
  });
}

class AuthBlocImageEvent extends AuthBlocEvent {
  final String? url;
  final String? name;
  final String? keyToStore;
  final Map<String, dynamic>? mapData;
  final Map<String, String>? saveToLocal;
  final List<String>? clearFromLocal;
  final Map<String, dynamic>? headers;
  final OnClickData? onClickData;
  final String? serverError;
  final String? folderName;
  final File? filePath;
  final String? collectionName;
  const AuthBlocImageEvent({
    required this.serverError,
    required this.onClickData,
    required this.saveToLocal,
    required this.clearFromLocal,
    required this.folderName,
    required this.filePath,
    required this.collectionName,
    required this.headers,
    required this.mapData,
    required this.url,
    required this.name,
    required this.keyToStore,
  });
}

class AuthBlocLiveLocationFetchinfgContinueEvent extends AuthBlocEvent {
  final String? serverError;
  final Map<String, dynamic> mapData;
  final String? folderName;
  final File? filePath;
  final String? collectionName;
  const AuthBlocLiveLocationFetchinfgContinueEvent({
    required this.serverError,
    required this.mapData,
    required this.folderName,
    required this.filePath,
    required this.collectionName,
  });
}

class AuthBlocEventRegister extends AuthBlocEvent {
  final bool isGoogleLogin;
  final bool isVerification;
  final String email;
  final String otp;
  final String cityId;
  final String societyId;
  final String blockId;

  AuthBlocEventRegister({
    this.isGoogleLogin = true,
    this.isVerification = false,
    this.email = "",
    this.otp = "",
    this.cityId = "",
    this.societyId = "",
    this.blockId = "",
  });
}

class AuthBlocEventRegisterProfile extends AuthBlocEvent {
  final String email;
  final String name;
  final String contact;
  final String gender;
  final String imgUrl;
  final String cityId;
  final String societyId;
  final String blockId;
  AuthBlocEventRegisterProfile({
    this.contact = "",
    this.name = "",
    this.gender = "",
    this.email = "",
    this.imgUrl = "",
    this.cityId = "",
    this.societyId = "",
    this.blockId = "",
  });
}
