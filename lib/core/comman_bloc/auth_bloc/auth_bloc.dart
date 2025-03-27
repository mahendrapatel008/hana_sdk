import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hana_sdk/configs/api_config.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/attendence_model.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/login_data.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_event.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_state.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/repository/firebase_service.dart';
import 'package:hana_sdk/core/model/upload_store_model.dart';
import 'package:hana_sdk/core/repo/common_repo.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:hana_sdk/errors/error_handler_new.dart';
import 'package:hana_sdk/network/api_result_handler.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final CommonRepository _repo = CommonRepository();

  AuthBloc() : super(AuthBlocStateInitial()) {
    on<AuthBlocGoogleLoginEvent>(_registerGoogleApi);
    on<AuthBlocImageEvent>(_imageUploadApi);
    on<AuthBlocRefreshTokenEvent>(_refreshTokenApi);
    on<AuthBlocLogoutEvent>(_logoutApi);
    on<AuthBlocCommonLoginEvent>(_commonLoginApi);
    on<AuthBlocDynamicCommonLoginEvent>(_commonDynamicLoginApi);
    on<AuthBlocCommonLocationFetcherEvent>(_commonLocationFetcherApi);
    on<AuthBlocCommonSubmitEvent>(_commonSubmitApi);
    on<AuthBlocCommonDeleteEvent>(commaonDeleteApi);
    on<AuthBlocCommonAttendenceEvent>(_commonattendenceApi);
    on<AuthBlocDataRefresh>(_dataRefresh);
  }

  Future<void> _commonLoginApi(
    AuthBlocCommonLoginEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    LoginData formJsonData = LoginData();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse = await _repo
        .commaonApi(data: event.mapData, url: ApiConfig.domain + event.apiName);

    mainDataResponse.fold(
      (failure) {
        formJsonData = failure.message.isNotEmpty
            ? LoginData(message: failure.message)
            : LoginData();
      },
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? LoginData.fromJson(responseData)
            : LoginData();
        SharedPrefs().accessToken = formJsonData.accessToken == null ||
                formJsonData.accessToken!.isEmpty
            ? SharedPrefs().accessToken
            : formJsonData.accessToken;
        SharedPrefs().refreshToken = formJsonData.refreshToken == null ||
                formJsonData.refreshToken!.isEmpty
            ? SharedPrefs().refreshToken
            : formJsonData.refreshToken;
        SharedPrefs().sId = formJsonData.userData?.sId == null ||
                formJsonData.userData!.sId!.isEmpty
            ? SharedPrefs().sId
            : formJsonData.userData?.sId;
      },
    );

    if (formJsonData.statusCode == 200 || formJsonData.statusCode == 201) {
      if (formJsonData.success == true) {
        emit(
          AuthBlocStateCommonLogin(
            message: formJsonData.message.toString(),
            pageName: event.pageName,
            onClickData: event.onClickData,
          ),
        );
      } else {
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      }
    } else {
      emit(AuthBlocStateRegisterError(
          serverError: event.serverError,
          errorMessage: formJsonData.message.toString()));
    }
  }

  Future<void> _commonDynamicLoginApi(
    AuthBlocDynamicCommonLoginEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    Map<String, dynamic> formJsonData = {};
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonDynamicApi(
      data: event.mapData,
      url: event.url,
      headers: event.headers,
      apiType: event.apiType,
    );

    mainDataResponse.fold(
      (failure) {
        formJsonData = {
          'message':
              failure.message.isNotEmpty ? failure.message : 'Unknown error',
          'statusCode': 500,
        };
      },
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? {
                ...responseData,
                'statusCode': 200,
              }
            : {};
      },
    );

    if ((formJsonData['statusCode'] == 200 ||
        formJsonData['statusCode'] == 201)) {
      if (event.clearFromLocal != null) {
        if (event.clearFromLocal!.isNotEmpty) {
          await _clearDataFromLocal(event.clearFromLocal);
        }
      }
      if (event.saveToLocal != null) {
        final saveToLocalKeys = event.saveToLocal;
        if (saveToLocalKeys is Map<String, dynamic>) {
          await _handleSaveToLocalKeys(saveToLocalKeys ?? {}, formJsonData);
        }
      }
      if (event.isLast == true) {
        emit(
          AuthBlocStateCommonLogin(
            message: formJsonData['message']?.toString() ?? 'Success',
            pageName: event.pageName ?? '',
            onClickData: event.onClickData,
          ),
        );
      }
    } else {
      emit(AuthBlocStateRegisterError(
        serverError: event.serverError,
        errorMessage: formJsonData['message']?.toString() ?? 'Unknown error',
      ));
    }
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
          await saveToLocal(localKey, value);
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

    return null;
  }

  Future<void> _commonLocationFetcherApi(
    AuthBlocCommonLocationFetcherEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonApi(
            data: event.mapData,
            url: ApiConfig.domain +
                ApiConfig.apiVersionNameLocationContinueousSaving);

    mainDataResponse.fold(
      (failure) {},
      (responseData) {},
    );
  }

  Future<void> _imageUploadApi(
    AuthBlocImageEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    UploadAndStoreModel formJsonData = UploadAndStoreModel();

    Either<ApiFailure, UploadAndStoreModel> mainDataResponse =
        await _repo.uploadStoreFile(
      headers: event.headers,
      keyToStore: event.keyToStore ?? 'file',
      filePath: event.filePath,
      url: event.url ?? '',
      name: event.name ?? '',
      folderName: event.folderName,
      collectionName: event.collectionName,
    );

    mainDataResponse.fold(
      (failure) {
        formJsonData = UploadAndStoreModel(message: failure.message);
      },
      (responseData) {
        formJsonData = UploadAndStoreModel.fromJson(responseData.toJson());
      },
    );

    if (formJsonData.statusCode == 200 || formJsonData.statusCode == 201) {
      if (formJsonData.success == true) {
        if (event.clearFromLocal != null) {
          if (event.clearFromLocal!.isNotEmpty) {
            await _clearDataFromLocal(event.clearFromLocal);
          }
        }
        if (event.onClickData?.imagePickerData?.saveToLocal != null) {
          final saveToLocalKeys = event.saveToLocal;
          if (saveToLocalKeys is Map<String, dynamic>) {
            await _handleSaveToLocalKeys(
                saveToLocalKeys ?? {}, formJsonData.toJson());
          }
        }
        emit(
          AuthBlocStateuploadAndStore(
            message: formJsonData.message ?? "File uploaded successfully",
          ),
        );
      } else {
        emit(AuthBlocStateRegisterError(
          serverError: event.serverError,
          errorMessage: formJsonData.message ?? "An unknown error occurred",
        ));
      }
    } else {
      emit(AuthBlocStateRegisterError(
        serverError: event.serverError,
        errorMessage: formJsonData.message ?? "Failed to upload the file",
      ));
    }
  }

  Future<void> _commonSubmitApi(
    AuthBlocCommonSubmitEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    LoginData formJsonData = LoginData();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse = await _repo
        .commaonApi(data: event.mapData, url: ApiConfig.commonSubmitEndPoint);

    mainDataResponse.fold(
      (failure) {
        formJsonData = failure.message.isNotEmpty
            ? LoginData(message: failure.message)
            : LoginData();
      },
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? LoginData.fromJson(responseData)
            : LoginData();
      },
    );

    if (formJsonData.statusCode == 200 || formJsonData.statusCode == 201) {
      if (formJsonData.success == true) {
        emit(
          AuthBlocStateCommonSubmitData(
              message: formJsonData.message.toString(),
              pageName: event.pageName,
              onClickData: event.onClickData),
        );
      } else {
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      }
    } else {
      emit(AuthBlocStateRegisterError(
          serverError: event.serverError,
          errorMessage: formJsonData.message.toString()));
    }
  }

  Future<void> commaonDeleteApi(
    AuthBlocCommonDeleteEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    LoginData formJsonData = LoginData();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonDeleteApi(
            data: event.mapData, url: ApiConfig.commonDeleteEndPoint);
    mainDataResponse.fold(
      (failure) {
        formJsonData = failure.message.isNotEmpty
            ? LoginData(message: failure.message)
            : LoginData();
      },
      (responseData) {
        SharedPrefs().hanaDependent = "";
        SharedPrefs().hanaDocumentId = "";
        formJsonData = responseData.isNotEmpty
            ? LoginData.fromJson(responseData)
            : LoginData();
      },
    );
    if (formJsonData.statusCode == 200 || formJsonData.statusCode == 201) {
      if (formJsonData.success == true) {
        emit(
          AuthBlocStateCommonDeleteAccountData(
              message: formJsonData.message.toString(),
              pageName: event.pageName,
              onClickData: event.onClickData),
        );
      } else {
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      }
    } else {
      emit(AuthBlocStateRegisterError(
          serverError: event.serverError,
          errorMessage: formJsonData.message.toString()));
    }
  }

  Future<void> _commonattendenceApi(
    AuthBlocCommonAttendenceEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    AttendenceModel formJsonData = AttendenceModel();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonApi(
            data: event.mapData, url: ApiConfig.commonAttendenceEndPoint);
    mainDataResponse.fold(
      (failure) {
        formJsonData = failure.message.isNotEmpty
            ? AttendenceModel(message: failure.message)
            : AttendenceModel();
      },
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? AttendenceModel.fromJson(responseData)
            : AttendenceModel();
      },
    );

    if (formJsonData.statusCode == 200 || formJsonData.statusCode == 201) {
      if (formJsonData.success == true) {
        SharedPrefs().attendenceId = formJsonData.attendenceId;
        SharedPrefs().locationDatabase = event.locationDatabase;
        SharedPrefs().locationfetcher = true;
        emit(
          AuthBlocStateCommonLogin(
            onClickData: event.onClickData,
            message: formJsonData.message.toString(),
            pageName: event.pageName,
          ),
        );
      } else {
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      }
    } else {
      emit(AuthBlocStateRegisterError(
          serverError: event.serverError,
          errorMessage: formJsonData.message.toString()));
    }
  }

  Future<void> _dataRefresh(
    AuthBlocDataRefresh event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateDataRefresh(
      mapData: event.mapData,
      saveToLocal: event.saveToLocal,
      url: event.url,
      headers: event.headers,
      serverError: event.serverError,
      pageName: event.pageName,
      onClickData: event.onClickData,
      previousClear: event.previousClear,
      clearFromLocal: event.clearFromLocal,
    ));
  }

  Future<void> _logoutApi(
    AuthBlocLogoutEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    LoginData formJsonData = LoginData();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonApi(
            data: event.mapData, url: ApiConfig.domain + ApiConfig.logout);

    mainDataResponse.fold(
      (failure) {
        formJsonData = failure.message.isNotEmpty
            ? LoginData(message: failure.message)
            : LoginData();
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      },
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? LoginData.fromJson(responseData)
            : LoginData();
        SharedPrefs().accessToken = formJsonData.accessToken;
        SharedPrefs().refreshToken = formJsonData.refreshToken;
        emit(AuthBlocStateLogoutSuccess());
      },
    );
  }

  Future<void> _refreshTokenApi(
    AuthBlocRefreshTokenEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    LoginData formJsonData = LoginData();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonApi(
            data: event.mapData,
            url: ApiConfig.domain + ApiConfig.refreshToken);

    mainDataResponse.fold(
      (failure) {
        formJsonData = failure.message.isNotEmpty
            ? LoginData(message: failure.message)
            : LoginData();
        emit(AuthBlocStateTokenError(
            errorMessage: formJsonData.message.toString()));
      },
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? LoginData.fromJson(responseData)
            : LoginData();
        SharedPrefs().accessToken = formJsonData.accessToken;
        SharedPrefs().refreshToken = formJsonData.refreshToken;
        emit(AuthBlocStateTokenSuccess());
      },
    );
  }

  Future<void> _registerGoogleApi(
    AuthBlocGoogleLoginEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthBlocStateLoading());
    User? firebaseResponse;
    await FirebaseAuthService().signInWithGoogle().then((value) {
      value.fold((failure) {
        failure.message == ResponseMessage.DEFAULT
            ? emit(AuthBlocStateInitial())
            : emit(AuthBlocStateRegisterError(
                serverError: event.serverError, errorMessage: failure.message));
      }, (response) {
        if (response?.email != null) {
          firebaseResponse = response;
        } else {
          return;
        }
      });
    });
    if (state is AuthBlocStateInitial || firebaseResponse == null) return;

    LoginData formJsonData = LoginData();
    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.commaonApi(data: {
      "username": firebaseResponse?.email,
      "appName": SharedPrefs().appName,
    }, url: ApiConfig.domain + ApiConfig.loginAuth);

    mainDataResponse.fold(
      (failure) => formJsonData = failure.message.isNotEmpty
          ? LoginData(message: failure.message, statusCode: failure.statusCode)
          : LoginData(),
      (responseData) {
        formJsonData = responseData.isNotEmpty
            ? LoginData.fromJson(responseData)
            : LoginData();
      },
    );

    if (formJsonData.statusCode == 200) {
      if (formJsonData.success == true) {
        SharedPrefs().accessToken = formJsonData.accessToken;
        SharedPrefs().refreshToken = formJsonData.refreshToken;
        SharedPrefs().userName = formJsonData.userData?.username;
        emit(AuthBlocStateLoginSuccess(pageName: event.pageName));
      } else {
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      }
    } else if (formJsonData.statusCode == 402) {
      LoginData formJsonData = LoginData();
      Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
          await _repo.commaonApi(data: {
        "appName": SharedPrefs().appName,
        "type": "oauth",
        "fullName": firebaseResponse?.displayName ?? 'User',
        "username": firebaseResponse?.email,
        "role": SharedPrefs().appRole,
      }, url: ApiConfig.domain + ApiConfig.signupAuth);

      mainDataResponse.fold(
        (failure) => formJsonData = failure.message.isNotEmpty
            ? LoginData(message: failure.message)
            : LoginData(),
        (responseData) {
          formJsonData = responseData.isNotEmpty
              ? LoginData.fromJson(responseData)
              : LoginData();
        },
      );
      if (formJsonData.statusCode == 200) {
        if (formJsonData.success == true) {
          SharedPrefs().accessToken = formJsonData.accessToken;
          SharedPrefs().refreshToken = formJsonData.refreshToken;
          SharedPrefs().userName = formJsonData.userData?.username;
          emit(AuthBlocStateRegisterSuccess(pageName: event.pageName));
        } else {
          emit(AuthBlocStateRegisterError(
              serverError: event.serverError,
              errorMessage: formJsonData.message.toString()));
        }
      } else {
        emit(AuthBlocStateRegisterError(
            serverError: event.serverError,
            errorMessage: formJsonData.message.toString()));
      }
    } else {
      emit(AuthBlocStateRegisterError(
          serverError: event.serverError,
          errorMessage: formJsonData.message.toString()));
    }
  }
}
