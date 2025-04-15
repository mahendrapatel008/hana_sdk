import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_event.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_state.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_bottom_navbar/dynamic_bottom_navbar.dart';
import 'package:hana_sdk/core/elements/dynamic_popup/dynamic_popup_dialog.dart';
import 'package:hana_sdk/core/elements/dynamic_popup/dynamic_popup_model.dart';
import 'package:hana_sdk/core/model/external_api_call_model.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/services/location_fetcher.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DynamicOnClickHandler {
  final OnClickData? onClickData;
  final String? dName;
  final FormController formController;
  final BuildContext context;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;
  Map<String, dynamic> mergedData;
  String locationResult;

  DynamicOnClickHandler({
    required this.onClickData,
    required this.formController,
    required this.dName,
    required this.mergedData,
    required this.context,
    required this.hanaPrerequisiteDesign,
    required this.locationResult,
  });

  Future<void> handleDynamicClickApi() async {
    // Ensure apiCallData is a List
    List<ExternalApiCallModel>? apiCalls = onClickData?.apiCallData;
    if (onClickData?.share == true) {
      final boundaryKey = globalKeyProvider.repaintBoundaryKey;
      await _captureAndSharePng(boundaryKey, 'From hana platform');
    } else {
      if (onClickData?.isOtherRemove == true) {
        formController.savePrerequisitesNameData.clear();
      }
      if (onClickData?.isSelectedRemove == true) {
        formController.savePrerequisitesNameData
            .where((name) =>
                name != dName &&
                (hanaPrerequisiteDesign ?? [])
                    .any((otherPrerequisite) => otherPrerequisite.name == name))
            .toList()
            .forEach((name) => formController.removePrerequisitesName(
                context, name as String?));
      }
      formController.savePrerequisitesName(context, dName);
      if (onClickData?.isBack == true) {
        Navigator.pop(context, onClickData?.isBack);
        savePageData.removeLast();
        return;
      }
      bool navigate =
          onClickData?.isForm == true ? formController.isFormValid() : true;
      if (navigate) {
        var pageName = onClickData?.pageName;
        formController.submitForm();
        if (apiCalls != null && apiCalls.isNotEmpty) {
          for (var i = 0; i < apiCalls.length; i++) {
            var apiCall = apiCalls[i];
            bool isLast =
                (i == apiCalls.length - 1); // Check if it's the last API call

            // Ensure body is properly extracted
            Map<String, dynamic>? body = apiCall.body != null
                ? jsonDecode(jsonEncode(apiCall.body))
                : null;

            final Map<String, dynamic> mapData = {};
            final Map<String, dynamic> parsedHeaders = {};

            if (onClickData?.wantPreviousData == true) {
              mapData.addAll(reFormData);
              formController.formData.addAll(reFormData);
            }
            if (onClickData?.reUseData == true) {
              reFormData = formController.formData;
            }

            if (apiCall.url != null && apiCall.url!.isNotEmpty) {
              if (body != null) {
                await resolveLocalPlaceholders(body);
                mapData.addAll(body);
              }

              final Map<String, dynamic>? headers = apiCall.headers;
              if (headers != null) {
                await resolveLocalPlaceholders(headers);
                parsedHeaders.addAll(headers);
              }

              if (onClickData?.pageName != null &&
                  onClickData!.pageName!.isNotEmpty) {
                BlocProvider.of<AuthBloc>(context).add(
                  AuthBlocDynamicCommonLoginEvent(
                    url: apiCall.url,
                    apiType: apiCall.apiType,
                    onClickData: onClickData,
                    mapData: mapData,
                    headers: parsedHeaders,
                    pageName: pageName,
                    isLast: isLast,
                    saveToLocal: apiCall.saveToLocal,
                    clearFromLocal: apiCall.clearFromLocal,
                    serverError: onClickData?.serverError,
                  ),
                );
              } else {
                context.read<AuthBloc>().add(AuthBlocDataRefresh(
                      saveToLocal: apiCall.saveToLocal,
                      clearFromLocal: apiCall.clearFromLocal,
                      url: apiCall.url,
                      onClickData: onClickData,
                      mapData: mapData,
                      headers: parsedHeaders,
                      pageName: pageName,
                      serverError: onClickData?.serverError,
                    ));
              }
            } else {
              if (onClickData?.pageIndex != null) {
                formController.onPressed?[onClickData!.pageIndex!](
                    formController.formData);
              } else {
                if (pageName != null && pageName.isNotEmpty) {
                  if (pageName == 'app-login') {
                    handleNavigation(pageName, onClickData, context);
                    pageName = SharedPrefs().appFirstPageName;
                    if (onClickData?.pageReplacement == true) {
                      context.pushReplacement(
                        '/dynamic_form',
                        extra: {
                          'token': '1',
                          'pageName': pageName,
                          'onPressed': formController.onPressed,
                          'context': context,
                        },
                      );
                    } else {
                      context.push(
                        '/dynamic_form',
                        extra: {
                          'token': '1',
                          'pageName': pageName,
                          'onPressed': formController.onPressed,
                          'context': context,
                        },
                      );
                    }
                  } else {
                    handleNavigation(pageName, onClickData, context);
                    if (onClickData?.pageReplacement == true) {
                      context.pushReplacement(
                        '/dynamic_form',
                        extra: {
                          'token': '1',
                          'pageName': pageName,
                          'onPressed': formController.onPressed,
                          'context': context,
                        },
                      );
                    } else {
                      context.push(
                        '/dynamic_form',
                        extra: {
                          'token': '1',
                          'pageName': pageName,
                          'onPressed': formController.onPressed,
                          'context': context,
                        },
                      );
                    }
                  }
                }
              }
            }
          }
        } else {
          if (onClickData?.pageIndex != null) {
            formController
                .onPressed?[onClickData!.pageIndex!](formController.formData);
          } else {
            if (pageName != null && pageName.isNotEmpty) {
              if (pageName == 'app-login') {
                handleNavigation(pageName, onClickData, context);
                pageName = SharedPrefs().appFirstPageName;
                if (onClickData?.pageReplacement == true) {
                  context.pushReplacement(
                    '/dynamic_form',
                    extra: {
                      'token': '1',
                      'pageName': pageName,
                      'context': context,
                    },
                  );
                } else {
                  context.push(
                    '/dynamic_form',
                    extra: {
                      'token': '1',
                      'pageName': pageName,
                      'context': context,
                    },
                  );
                }
              } else {
                handleNavigation(pageName, onClickData, context);
                if (onClickData?.pageReplacement == true) {
                  context.pushReplacement(
                    '/dynamic_form',
                    extra: {
                      'token': '1',
                      'pageName': pageName,
                      'context': context,
                    },
                  );
                } else {
                  context.push(
                    '/dynamic_form',
                    extra: {
                      'token': '1',
                      'pageName': pageName,
                      'context': context,
                    },
                  );
                }
              }
            }
          }
        }
      }
    }
  }

  Future<void> resolveLocalPlaceholders(Map<String, dynamic> mapData) async {
    for (var key in mapData.keys) {
      var value = mapData[key];

      if (value is String && value.contains('{localVar}')) {
        final regex = RegExp(r'\{localVar\},(.*?\{(\w+)\}.*?)');
        final match = regex.firstMatch(value);

        if (match != null) {
          final fullTemplate = match.group(1)!;
          final localKey = match.group(2)!;
          try {
            final localValue = await getLocalStorageValue(localKey);

            if (localValue != null) {
              final resolvedValue = fullTemplate.replaceAll(
                '{$localKey}',
                localValue.toString(),
              );
              mapData[key] = resolvedValue;
            } else {
              throw Exception('localVar value for key $localKey not found.');
            }
          } catch (e) {
            print('Error fetching local value for key $localKey: $e');
          }
        }
      } else if (value is String && value.contains('{control}')) {
        final regex = RegExp(r'\{control\},(.*?\{(\w+)\}.*?)');
        final match = regex.firstMatch(value);

        if (match != null) {
          final fullTemplate = match.group(1)!;
          final controlKey = match.group(2)!;
          try {
            final controlValue =
                formController.formData[controlKey]?.toString() ?? '';

            if (controlValue.isNotEmpty) {
              final resolvedValue = fullTemplate.replaceAll(
                '{$controlKey}',
                controlValue.toString(),
              );
              mapData[key] = resolvedValue;
            } else {
              throw Exception('control value for key $controlKey not found.');
            }
          } catch (e) {
            print('Error fetching control value for key $controlKey: $e');
          }
        }
      } else if (value is String && value.contains('{listIndex}')) {
        final regex = RegExp(r'\{listIndex\},(.*?\{(\w+)\}.*?)');
        final match = regex.firstMatch(value);

        if (match != null) {
          final fullTemplate = match.group(1)!;
          final controlKey = match.group(2)!;
          try {
            final controlValue = hanaVar1[controlKey].toString();

            if (controlValue.isNotEmpty) {
              final resolvedValue = fullTemplate.replaceAll(
                '{$controlKey}',
                controlValue.toString(),
              );
              mapData[key] = resolvedValue;
            } else {
              throw Exception('listIndex value for key $controlKey not found.');
            }
          } catch (e) {
            print('Error fetching listIndex value for key $controlKey: $e');
          }
        }
      } else if (value is String && value.contains('{listVar}')) {
        final regex = RegExp(r'\{listVar\},(.*?\{(\w+)\}.*?)');
        final match = regex.firstMatch(value);

        if (match != null) {
          final fullTemplate = match.group(1)!;
          final controlKey = match.group(2)!;
          try {
            final controlValue =
                universalListData?[universalIndex ?? 0][controlKey].toString();

            if (controlValue != null && controlValue.isNotEmpty) {
              final resolvedValue = fullTemplate.replaceAll(
                '{$controlKey}',
                controlValue.toString(),
              );
              mapData[key] = resolvedValue;
            } else {
              throw Exception('listVar value for key $controlKey not found.');
            }
          } catch (e) {
            print('Error fetching listVar value for key $controlKey: $e');
          }
        }
      } else if (value is String && value.contains('{systemVar}')) {
        final regex = RegExp(r'\{systemVar\},(.?\{(\w+)\}.?)');
        final match = regex.firstMatch(value);

        if (match != null) {
          final fullTemplate = match.group(1)!;
          final systemVarKey = match.group(2)!;
          try {
            String systemVarValue = '';
            if (systemVarKey == 'randomString') {
              systemVarValue = getRandomString(11);
            }
            if (systemVarKey == 'createdAt') {
              systemVarValue = generateId();
            }
            if (systemVarKey == 'getCurrentDateTime') {
              systemVarValue = getCurrentDateTime();
            }
            if (systemVarKey == 'getCurrentTime') {
              systemVarValue = generateCurrentTime();
            }
            if (systemVarKey == 'getCurrentDate') {
              systemVarValue = generateCurrentDate();
            }
            if (systemVarKey == 'ip') {
              systemVarValue = await getIpAddress();
            }
            if (systemVarKey == 'device') {
              systemVarValue = await getDeviceInfo();
            }
            if (systemVarKey == 'latitude' ||
                systemVarKey == 'longitude' ||
                systemVarKey == 'address') {
              await fetchCurrentLocation("{name} {locality}, {country}");
              if (systemVarKey == 'latitude') {
                systemVarValue = SharedPrefs().latitude.toString();
              }
              if (systemVarKey == 'longitude') {
                systemVarValue = SharedPrefs().longitude.toString();
              }
              if (systemVarKey == 'address') {
                systemVarValue = SharedPrefs().locationAddress.toString();
              }
            }

            if (systemVarValue.isNotEmpty) {
              final resolvedValue = fullTemplate.replaceAll(
                '{$systemVarKey}',
                systemVarValue.toString(),
              );
              mapData[key] = resolvedValue;
            } else {
              throw Exception(
                  'systemVar value for key $systemVarKey not found.');
            }
          } catch (e) {
            print('Error fetching systemVar value for key $systemVarKey: $e');
          }
        }
      } else if (value is Map<String, dynamic>) {
        await resolveLocalPlaceholders(value);
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          if (value[i] is Map<String, dynamic>) {
            await resolveLocalPlaceholders(value[i] as Map<String, dynamic>);
          } else if (value[i] is String && value[i].contains('{localVar}')) {
            final regex = RegExp(r'\{localVar\},(.*?\{(\w+)\}.*?)');
            final match = regex.firstMatch(value[i]);

            if (match != null) {
              final fullTemplate = match.group(1)!;
              final localKey = match.group(2)!;
              try {
                final localValue = await getLocalStorageValue(localKey);

                if (localValue != null) {
                  value[i] = fullTemplate.replaceAll(
                    '{$localKey}',
                    localValue.toString(),
                  );
                } else {
                  throw Exception(
                      'localVar value for key $localKey not found.');
                }
              } catch (e) {
                print('Error fetching local value for key $localKey: $e');
              }
            }
          } else if (value[i] is String && value[i].contains('{control}')) {
            final regex = RegExp(r'\{control\},(.*?\{(\w+)\}.*?)');
            final match = regex.firstMatch(value[i]);

            if (match != null) {
              final fullTemplate = match.group(1)!;
              final controlKey = match.group(2)!;
              try {
                final controlValue =
                    formController.formData[controlKey]?.toString() ?? '';

                if (controlValue.isNotEmpty) {
                  value[i] = fullTemplate.replaceAll(
                    '{$controlKey}',
                    controlValue.toString(),
                  );
                } else {
                  throw Exception(
                      'control value for key $controlKey not found.');
                }
              } catch (e) {
                print('Error fetching control value for key $controlKey: $e');
              }
            }
          } else if (value[i] is String && value[i].contains('{listIndex}')) {
            final regex = RegExp(r'\{listIndex\},(.*?\{(\w+)\}.*?)');
            final match = regex.firstMatch(value[i]);

            if (match != null) {
              final fullTemplate = match.group(1)!;
              final controlKey = match.group(2)!;
              try {
                final controlValue = hanaVar1[controlKey]?.toString() ?? '';

                if (controlValue.isNotEmpty) {
                  value[i] = fullTemplate.replaceAll(
                    '{$controlKey}',
                    controlValue.toString(),
                  );
                } else {
                  throw Exception(
                      'listIndex value for key $controlKey not found.');
                }
              } catch (e) {
                print('Error fetching listIndex value for key $controlKey: $e');
              }
            }
          } else if (value[i] is String && value[i].contains('{listVar}')) {
            final regex = RegExp(r'\{listVar\},(.*?\{(\w+)\}.*?)');
            final match = regex.firstMatch(value[i]);

            if (match != null) {
              final fullTemplate = match.group(1)!;
              final controlKey = match.group(2)!;
              try {
                final controlValue = universalListData?[universalIndex ?? 0]
                            [controlKey]
                        ?.toString() ??
                    '';

                if (controlValue.isNotEmpty) {
                  value[i] = fullTemplate.replaceAll(
                    '{$controlKey}',
                    controlValue.toString(),
                  );
                } else {
                  throw Exception(
                      'listVar value for key $controlKey not found.');
                }
              } catch (e) {
                print('Error fetching listVar value for key $controlKey: $e');
              }
            }
          } else if (value is String && value.contains('{systemVar}')) {
            final regex = RegExp(r'\{systemVar\},(.?\{(\w+)\}.?)');
            final match = regex.firstMatch(value[i]);

            if (match != null) {
              final fullTemplate = match.group(1)!;
              final systemVarKey = match.group(2)!;
              try {
                String systemVarValue = '';
                if (systemVarKey == 'randomString') {
                  systemVarValue = getRandomString(11);
                }
                if (systemVarKey == 'createdAt') {
                  systemVarValue = generateId();
                }
                if (systemVarKey == 'getCurrentDateTime') {
                  systemVarValue = getCurrentDateTime();
                }
                if (systemVarKey == 'getCurrentTime') {
                  systemVarValue = generateCurrentTime();
                }
                if (systemVarKey == 'getCurrentDate') {
                  systemVarValue = generateCurrentDate();
                }
                if (systemVarKey == 'ip') {
                  systemVarValue = await getIpAddress();
                }
                if (systemVarKey == 'device') {
                  systemVarValue = await getDeviceInfo();
                }
                if (systemVarKey == 'latitude' ||
                    systemVarKey == 'longitude' ||
                    systemVarKey == 'address') {
                  await fetchCurrentLocation("{name} {locality}, {country}");
                  if (systemVarKey == 'latitude') {
                    systemVarValue = SharedPrefs().latitude.toString();
                  }
                  if (systemVarKey == 'longitude') {
                    systemVarValue = SharedPrefs().longitude.toString();
                  }
                  if (systemVarKey == 'address') {
                    systemVarValue = SharedPrefs().locationAddress.toString();
                  }
                }

                if (systemVarValue.isNotEmpty) {
                  final resolvedValue = fullTemplate.replaceAll(
                    '{$systemVarKey}',
                    systemVarValue.toString(),
                  );
                  mapData[key] = resolvedValue;
                } else {
                  throw Exception(
                      'systemVar value for key $systemVarKey not found.');
                }
              } catch (e) {
                print(
                    'Error fetching systemVar value for key $systemVarKey: $e');
              }
            }
          }
        }
      }
    }
  }

  Future<void> _captureAndSharePng(
      GlobalKey<State<StatefulWidget>> globalKey, String messege) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String dir = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$dir/share_temp.png');
      await imgFile.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(imgFile.path)], text: messege);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> handleDynamicClick() async {
    if (onClickData?.imagePickerData?.openCamera == true ||
        onClickData?.imagePickerData?.openGallery == true) {
      handlePictureClick(onClickData);
    } else if (onClickData?.popupData != null) {
      handlePopup();
    } else {
      handleDynamicClickApi();
    }
  }

  Future<void> handlePictureClick(OnClickData? onClickData) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: onClickData?.imagePickerData?.openCamera == true
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 50);
    if (image != null) {
      final File file = File(image.path);

      if (onClickData?.imagePickerData?.openGallery == true) {
        SharedPrefs().galleryImage = file;
      }
      if (onClickData?.imagePickerData?.isBase64 == true) {
        final List<int> imageBytes = await file.readAsBytes();
        final String base64String = base64Encode(imageBytes);
        formController.saveFieldValue(
          (onClickData?.imagePickerData?.name ??
              onClickData?.imagePickerData?.id ??
              ''),
          base64String,
        );
        handleDynamicClickApi();
      } else {
        final Map<String, dynamic> parsedHeaders = {};
        final Map<String, dynamic>? headers =
            onClickData?.imagePickerData?.headers;
        if (headers != null) {
          await resolveLocalPlaceholders(headers);
          parsedHeaders.addAll(headers);
        }
        BlocProvider.of<AuthBloc>(context).add(
          AuthBlocImageEvent(
            saveToLocal: onClickData?.imagePickerData?.saveToLocal,
            clearFromLocal: onClickData?.imagePickerData?.clearFromLocal,
            onClickData: onClickData,
            name: onClickData?.imagePickerData?.name,
            keyToStore: onClickData?.imagePickerData?.keyToStore,
            url: onClickData?.imagePickerData?.url,
            headers: parsedHeaders,
            mapData: onClickData?.imagePickerData?.body,
            filePath: file,
            folderName: file.path,
            serverError: onClickData?.serverError,
            collectionName: onClickData?.collectionToSubmit,
          ),
        );
        context.read<AuthBloc>().stream.listen((state) {
          if (state is AuthBlocStateuploadAndStore) {
            handleDynamicClickApi();
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onClickData?.imagePickerData?.openCamera == true
              ? 'Camera was cancelled.'
              : 'Gallery closed.'),
        ),
      );
      return;
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {}
  }

  Future<void> handlePopup() async {
    DynamicPopupDialog.showPopupDialog(
      model: DynamicPopupModel(
        title: onClickData?.popupData?.title,
        content: onClickData?.popupData?.content,
        confirmButtonText: onClickData?.popupData?.confirmButtonText,
        cancelButtonText: onClickData?.popupData?.cancelButtonText,
        backgroundColor: Colors.white,
        borderRadius: 10,
      ),
      formController: formController,
      confirmButtonTextOnpressed: () {
        handleDynamicClickApi();
      },
      context: context,
    );
  }

  Future<void> _handleNavigationAndApiCalls() async {
    if (onClickData?.wantPreviousData == true) {
      mergedData = {
        ...formController.formData,
        ...reFormData,
      };
    } else {
      mergedData = formController.formData;
    }
    if (onClickData?.reUseData == true) {
      reFormData = formController.formData;
    }
    onClickData?.isOtherRemove == true
        ? formController.savePrerequisitesNameData.clear()
        : null;
    // start
    if (onClickData?.isSelectedRemove == true) {
      formController.savePrerequisitesNameData
          .where((name) =>
              name != dName &&
              (hanaPrerequisiteDesign ?? [])
                  .any((otherPrerequisite) => otherPrerequisite.name == name))
          .toList()
          .forEach((name) =>
              formController.removePrerequisitesName(context, name as String?));

      // displayController.hanaPrerequisiteDesign!
      //     .where((prerequisite) =>
      //         savePrerequisitesNameData.contains(prerequisite.name))
      //     .toList();
    }
    formController.savePrerequisitesName(context, dName);
    if (onClickData?.isBack == true) {
      Navigator.pop(context, onClickData?.isBack);
      savePageData.removeLast();
      return;
    }
    bool navigate = false;
    if (onClickData?.isForm == true) {
      formController.isFormValid() ? navigate = true : navigate = false;
    } else {
      navigate = true;
    }
    if (navigate) {
      // Proceed with the form submission or navigation
      if (formController.formData.containsKey('hanaDependent')) {
        SharedPrefs().hanaDependent = formController.formData['hanaDependent'];
      }
      if (formController.formData.containsKey('hanaDateDependent')) {
        SharedPrefs().hanaDateDependent =
            formController.formData['hanaDateDependent'];
      }
      if (formController.formData.containsKey('hanaMonthDependent')) {
        SharedPrefs().hanaMonthDependent =
            formController.formData['hanaMonthDependent'];
      }
      if (formController.formData.containsKey('hanaYearDependent')) {
        SharedPrefs().hanaYearDependent =
            formController.formData['hanaYearDependent'];
      }
      formController.submitForm();
      if (onClickData?.query != null && onClickData!.query!.isNotEmpty) {
        // context.read<AuthBloc>().add(AuthBlocDataRefresh(
        //     mapData: onClickData!.query!,
        //     previousClear: onClickData!.isPreviousQueryClear));
      } else {
        if (onClickData != null) {
          var apiName = onClickData?.apiName;
          var pageName = onClickData?.pageName;
          if (apiName != null && apiName.isNotEmpty) {
            if (apiName == 'google') {
              BlocProvider.of<AuthBloc>(context).add(AuthBlocGoogleLoginEvent(
                mapData: {},
                pageName: pageName,
                serverError: onClickData?.serverError,
              ));
            } else if (apiName == 'log-out') {
              SharedPrefs.clearSharedPref();
              savePageData.clear();
              Navigator.popUntil(context, (route) => route.isFirst);
              context.pushReplacement(
                '/splash',
                // extra: {'selectedIndex': 0},
              );
            } else {
              mergedData['role'] = SharedPrefs().appRole;
              mergedData['appName'] = SharedPrefs().appName;
              BlocProvider.of<AuthBloc>(context).add(
                AuthBlocCommonLoginEvent(
                    serverError: onClickData?.serverError,
                    onClickData: onClickData,
                    pageName: pageName ?? '',
                    apiName: apiName,
                    mapData: mergedData),
              );
            }
          } else {
            if (onClickData?.pageType == 'bottomNavBar') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BottomNavbarPageWrapper(
                        formController: formController,
                        bottomNavModel: onClickData?.navBarData,
                        sideNavModel: onClickData?.sideNavBarData,
                        // selectedIndex: 0,
                      )));
            } else {
              if (pageName != null && pageName.isNotEmpty) {
                if (pageName == 'app-login') {
                  handleNavigation(pageName, onClickData, context);
                  pageName = SharedPrefs().appFirstPageName;
                  if (onClickData?.pageReplacement == true) {
                    context.pushReplacement(
                      '/dynamic_form',
                      extra: {'token': '1', 'pageName': pageName},
                    );
                  } else {
                    context.push(
                      '/dynamic_form',
                      extra: {'token': '1', 'pageName': pageName},
                    ).then((result) {
                      if (result == true) {
                        // Trigger the refresh event
                        // context.read<AuthBloc>().add(AuthBlocDataRefresh(
                        //     mapData: formController.dynamicLookUp,
                        //     previousClear: true));
                      }
                    });
                  }
                } else {
                  handleNavigation(pageName, onClickData, context);
                  if (onClickData?.pageReplacement == true) {
                    context.pushReplacement(
                      '/dynamic_form',
                      extra: {'token': '1', 'pageName': pageName},
                    );
                  } else {
                    context.push(
                      '/dynamic_form',
                      extra: {'token': '1', 'pageName': pageName},
                    ).then((result) {
                      if (result == true) {
                        // Trigger the refresh event
                        // context.read<AuthBloc>().add(AuthBlocDataRefresh(
                        //     mapData: formController.dynamicLookUp,
                        //     previousClear: true));
                      }
                    });
                  }
                }
              }
            }
          }
        }
      }
    } else {
      // Optionally show an error message or handle invalid form state
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Row(
      //       children: [
      //         Icon(
      //           Icons.error_outline,
      //           color: Colors.white,
      //           size: 24,
      //         ),
      //         SizedBox(width: 12),
      //         Expanded(
      //           child: Text(
      //             "Please correct the errors in the form before submitting.",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 16,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     backgroundColor: Colors.redAccent,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     action: SnackBarAction(
      //       label: 'DISMISS',
      //       textColor: Colors.yellowAccent,
      //       onPressed: () {
      //         // Dismiss action
      //       },
      //     ),
      //     duration: const Duration(seconds: 4),
      //     margin: const EdgeInsets.all(16),
      //     padding:
      //         const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      //   ),
      // );

      DynamicPopupDialog.showPopupDialog(
        model: DynamicPopupModel(
          title: "Error",
          content: formController.validationErrors.values.join('\n'),
          confirmButtonText: "OK",

          // cancelButtonText: "No",
          backgroundColor: Colors.white,
          borderRadius: 10,
        ),
        formController: formController,
        context: context,
      );
    }
  }

  // Future<void> _handleApiAndNavigation() async {
  //   final apiName = onClickData?.apiName;
  //   final pageName = onClickData?.pageName;

  //   if (apiName != null && apiName.isNotEmpty) {
  //     await _handleApiCall(apiName, pageName);
  //   } else {
  //     // await _handleNavigation(pageName);
  //   }
  // }

  // Future<void> _handleApiCall(String apiName, String? pageName) async {
  //   if (apiName == 'google') {
  //     BlocProvider.of<AuthBloc>(context)
  //         .add(AuthBlocGoogleLoginEvent(mapData: {}, pageName: pageName,));
  //   } else if (apiName == 'resend-otp') {
  //     BlocProvider.of<AuthBloc>(context).add(AuthBlocCommonLoginEvent(
  //       onClickData: onClickData,
  //       mapData: {
  //         "appName": SharedPrefs().appName,
  //         "username": SharedPrefs().userName,
  //         "role": SharedPrefs().appRole,
  //       },
  //       pageName: '',
  //       apiName: 'loginWithOtp',
  //     ));
  //   } else if (apiName == 'log-out') {
  //     SharedPrefs.clearSharedPref();
  //     Navigator.popUntil(context, (route) => route.isFirst);
  //     context.pushReplacement('/splash');
  //   } else if (apiName == 'submitData') {
  //     if (onClickData?.withUser == true) {
  //       mergedData['username'] = SharedPrefs().sId;
  //     }
  //     BlocProvider.of<AuthBloc>(context).add(AuthBlocCommonSubmitEvent(
  //       onClickData: onClickData,
  //       pageName: pageName ?? '',
  //       mapData: {
  //         "collectionToSubmit": onClickData?.collectionToSubmit,
  //         "sectionName": onClickData?.sectionName,
  //         "appName": SharedPrefs().appName,
  //         "sectionData": mergedData,
  //       },
  //     ));
  //   }
  // }

  void showErrorDialog(String title, String content) {
    DynamicPopupDialog.showPopupDialog(
      model: DynamicPopupModel(
        title: title,
        content: content,
        confirmButtonText: "OK",
        backgroundColor: Colors.white,
        borderRadius: 10,
      ),
      formController: formController,
      context: context,
    );
  }
}
