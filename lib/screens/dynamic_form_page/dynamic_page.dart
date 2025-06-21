library hana_sdk;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart' as form;
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_data.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_form.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_state.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_event.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_state.dart';
import 'package:hana_sdk/core/controllers/api_element_controller.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar_model.dart';
import 'package:hana_sdk/core/elements/dynamic_popup/dynamic_popup_dialog.dart';
import 'package:hana_sdk/core/elements/dynamic_popup/dynamic_popup_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/repo/repository.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/constants.dart';
import 'package:hana_sdk/core/utils/device_utility.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicFormScreen extends StatefulWidget {
  final String token;
  final String pageName;
  final String? appName;
  final bool? isFromList;
  final BuildContext context;
  final form.FormController formController;
  final Map<String, dynamic>? listData;
  final List<dynamic Function(Map<String, dynamic>)>? onPressed;
  const DynamicFormScreen({
    super.key,
    required this.token,
    required this.pageName,
    this.appName,
    required this.context,
    required this.formController,
    this.isFromList,
    this.listData,
    this.onPressed,
  });

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  List<FormSectionMain> formSections = [];

  Widget? formWidgets;
  List<Widget> appBarWidgets = [];
  bool isLoading = false;
  bool isPageLoad = false;
  DynamicAppbarModel dynamicAppbarModel = DynamicAppbarModel();

  String dynamicPageName = '';
  String dynamicModuleName = '';
  DynamicForm dynamicForm = DynamicForm(form: [], name: '');
  DynamicForm tempDynamicForm = DynamicForm(form: [], name: '');
  String dynamicFormString = '';
  DynamicData dynamicData = DynamicData(dynamicData: {});
  String sharedPrefData = '';
  String sharedPrefDataQuery = '';
  late GoRouter _router;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = GoRouter.of(context); // Safe here
  }

  Future<void> _initFunctions() async {
    // sharedPrefData = SharedPrefs().getString(widget.pageName) ?? '';
    // sharedPrefDataQuery =
    //     SharedPrefs().getString("${widget.pageName}query") ?? '';

    // if (sharedPrefData.isNotEmpty) {
    //   try {
    //     Map<String, dynamic> sharedPrefDataMap = jsonDecode(sharedPrefData);
    //     if (sharedPrefDataMap.isNotEmpty) {
    //       dynamicForm = await DynamicForm.fromJson(sharedPrefDataMap, false);
    //       tempDynamicForm =
    //           await DynamicForm.fromJson(sharedPrefDataMap, false);
    //     } else {
    //       print("sharedPrefDataMap is empty or does not contain valid data");
    //     }
    //   } catch (e) {
    //     print("Error decoding sharedPrefData: $e");
    //   }

    //   if (sharedPrefDataQuery.isNotEmpty && widget.isFromList != true) {
    //     try {
    //       dynamicData = DynamicData.fromJson(jsonDecode(sharedPrefDataQuery));
    //       formController.saveFieldNameData(
    //           dynamicData.dynamicData as Map<String, dynamic>, false);
    //     } catch (e) {
    //       print("Error decoding sharedPrefDataQuery: $e");
    //     }
    //   }

    //   dynamicPageName = '';
    //   dynamicPageName = dynamicForm.name;
    //   dynamicPageNameString = '';
    //   dynamicPageNameString = dynamicForm.name;
    //   if (savePageData.isNotEmpty) {
    //     if (savePageData.last.toString() != dynamicForm.name) {
    //       if (!savePageData.contains(dynamicForm.name)) {
    //         savePageData.add(dynamicForm.name);
    //       }
    //     }
    //   } else {
    //     if (!savePageData.contains(dynamicForm.name)) {
    //       savePageData.add(dynamicForm.name);
    //     }
    //   }
    //   dynamicPageName = dynamicPageName;
    //   formSections.addAll(dynamicForm.form);
    //   // formWidgets.clear();
    //   appBarWidgets.clear();
    //   if (dynamicForm.dynamicAppbar != null) {
    //     dynamicAppbarModel = dynamicForm.dynamicAppbar!;
    //   }

    //   setState(() {
    //     isPageLoad = true;
    //     isLoading = false;
    //   });
    // } else {
    //   setState(() {
    //     isLoading = true;
    //   });
    // }

    // Call the background data fetch function
    log('this is appName: ${widget.appName}');
    if (widget.appName != null && widget.appName!.isNotEmpty) {
      SharedPrefs().appName = widget.appName;
    }
    SharedPrefs().appModuleName = 'mobileappdesign';

    await _fetchAndUpdateDataInBackground();
  }

  Future<void> _fetchAndUpdateDataInBackground() async {
    ApiFormRepository apiFormRepository = ApiFormRepository();
    widget.formController.clearFieldNameData();
    widget.formController.savePrerequisitesNameData.clear();
    widget.formController.saveFieldNameLookUp(dynamicForm.dynamicLookup, null);

    dynamicForm = await apiFormRepository.getModuleData(
      appName: widget.pageName == 'app-login'
          ? 'app8978545688887'
          : SharedPrefs().appName,
      moduleName: widget.pageName == 'app-login'
          ? 'mobileappdesign'
          : SharedPrefs().appModuleName.isEmpty
              ? 'mobileappdesign'
              : SharedPrefs().appModuleName,
      query: {"sectionData.mobilejson.name": widget.pageName},
      limit: 100,
    );
    dynamicModuleName = dynamicForm.moduleName ?? "message";

    // Fetch dynamic lookups if applicable
    if (dynamicForm.dynamicLookup != null &&
        dynamicForm.dynamicLookup!.isNotEmpty) {
      Map<String, dynamic> mergedDynamicData = {};
      List<dynamic> mergedDynamicDataA = [];
      for (var i = 0; i < dynamicForm.dynamicLookup!.length; i++) {
        var lookup = dynamicForm.dynamicLookup![i];
        DynamicData fetchedData =
            await apiFormRepository.getDynamicLookUpsModuleData(
          index: i.toString(),
          url: lookup.url,
          body: lookup.body,
          headers: lookup.headers,
          saveToLocal: lookup.saveToLocal,
          clearFromLocal: lookup.clearFromLocal,
        );
        Map<String, dynamic> fetchedDataMap = fetchedData.dynamicData ?? {};
        mergedDynamicData.addAll(fetchedDataMap);
        mergedDynamicDataA.add(fetchedDataMap);
      }
      // dynamicData = DynamicData(dynamicData: mergedDynamicData);
      // // Convert raw dynamicData into key-value pairs
      // Map<String, dynamic> dynamicDataKeyValue =
      //     convertDynamicDataToKeyValue(dynamicData);

      // // Save the processed key-value data
      // formController.saveFieldNameData(dynamicDataKeyValue, false);

      for (var data in mergedDynamicDataA) {
        DynamicData dynamicData = DynamicData(dynamicData: data);
        Map<String, dynamic> dynamicDataKeyValue =
            convertDynamicDataToKeyValue(dynamicData);
        widget.formController.saveFieldNameData(dynamicDataKeyValue, false);
      }
    }
    dynamicPageName = '';
    dynamicPageName = dynamicForm.name;
    dynamicPageNameString = '';
    dynamicPageNameString = dynamicForm.name;
    if (savePageData.isNotEmpty) {
      if (savePageData.last.toString() != dynamicForm.name) {
        if (!savePageData.contains(dynamicForm.name)) {
          savePageData.add(dynamicForm.name);
        }
      }
    } else {
      if (!savePageData.contains(dynamicForm.name)) {
        savePageData.add(dynamicForm.name);
      }
    }
    formSections.addAll(dynamicForm.form);
    appBarWidgets.clear();
    if (dynamicForm.dynamicAppbar != null) {
      dynamicAppbarModel = dynamicForm.dynamicAppbar!;
    }
    setState(() {
      isPageLoad = true;
      isLoading = false;
    });
  }

  Map<String, dynamic> convertDynamicDataToKeyValue(dynamic dynamicData) {
    Map<String, dynamic> keyValueMap = {};

    // Handle DynamicData type explicitly
    if (dynamicData is DynamicData) {
      dynamicData = dynamicData.dynamicData; // Extract the raw dynamicData list
    }

    // Function to process nested maps or lists recursively
    void processNested(dynamic data, [String? parentKey]) {
      if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          final newKey = parentKey != null ? '$parentKey.$key' : key;
          if (value is Map || value is List) {
            keyValueMap[newKey.toString()] = value;
            processNested(value, newKey);
          } else {
            keyValueMap[newKey.toString()] = value;
          }
        });
      } else if (data is List) {
        for (var i = 0; i < data.length; i++) {
          final newKey = parentKey != null ? '$parentKey[$i]' : '[$i]';
          processNested(data[i], newKey);
        }
      } else {
        // If the data is not a Map or List, add it directly
        if (parentKey != null) {
          keyValueMap[parentKey.toString()] = data;
        }
      }
    }

    // Start processing the input data
    processNested(dynamicData);

    log("Converted Key-Value Data: ${json.encoder.convert(keyValueMap)}");
    return keyValueMap;
  }

  Future<void> _initFunctions1(
      final String? url,
      Map<String, dynamic>? mapData,
      Map<String, dynamic>? headers,
      OnClickData? onClickData,
      String? serverError,
      final Map<String, String>? saveToLocal,
      final List<String>? clearFromLocal,
      bool? previousClear) async {
    try {
      ApiFormRepository apiFormRepository = ApiFormRepository();
      // Fetch the dynamic data
      dynamicData = await apiFormRepository.getDynamicLookUpsModuleData(
          url: url,
          body: mapData,
          headers: headers,
          saveToLocal: saveToLocal,
          clearFromLocal: clearFromLocal);

      // Process and convert dynamic data to key-value pairs
      Map<String, dynamic> dynamicDataKeyValue =
          convertDynamicDataToKeyValue(dynamicData);

      // Save the processed key-value data
      widget.formController.saveFieldNameData(dynamicDataKeyValue, false);

      // Dispatch the RefreshFormEvent only after data processing is complete
      BlocProvider.of<RefreshBloc>(widget.context)
          .add(RefreshFormEvent(check: ''));
    } catch (e) {
      // Handle errors gracefully
      log("Error in _initFunctions: $e");
    }
  }

  Future<void> _refresh() async {
    SchedulerBinding.instance.addPostFrameCallback((_) => _initFunctions());
  }

  @override
  void initState() {
    print('''
========================================
         Mahendra Patel
----------------------------------------
    Creator: Product by Mahendra Patel
    Details: Contact mp304813@gmail.com for more!
========================================
''');
    super.initState();
    if (widget.onPressed != null && widget.onPressed!.isNotEmpty) {
      utilOnPressed = widget.onPressed;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) => _initFunctions());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // Dismiss the dialog
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              if (TDeviceUtils.isAndroid()) {
                exit(0);
              } else if (TDeviceUtils.isIOS()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isPageLoad) {
      isPageLoad = false;
      for (var section in formSections) {
        var formElement = ApiFormElements.fromJson({
          "type": section.fields["type"],
          "items": section.fields,
        });
        formElement.formController = widget.formController;
        var apiElementController =
            ApiElementController(formSectionsElements: formElement);
        formWidgets = apiElementController.buildFormElement();
      }

      if (dynamicAppbarModel.title != null) {
        if (dynamicAppbarModel.items != null) {
          if (dynamicAppbarModel.items!.isNotEmpty) {
            var fields = dynamicAppbarModel.items;
            for (var field in fields ?? []) {
              var formElement = ApiFormElements.fromJson({
                "type": field['type'],
                "items": field,
              });
              formElement.formController = widget.formController;
              var apiElementController =
                  ApiElementController(formSectionsElements: formElement);
              appBarWidgets.add(apiElementController.buildFormElement());
            }
          }
        }
      }
    }
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     print("EasyLoading>>>>>>will$savePageData");
        //     if (savePageData.length == 1) {
        //       _showExitDialog(context);
        //       return false;
        //     }
        //     savePageData.removeLast();
        //     dynamicPageNameString = savePageData[savePageData.length - 1];
        //     Navigator.pop(context);
        //     return true;
        //   },
        // child:
        BlocListener<AuthBloc, AuthBlocState>(
            listener: (context, state) {
              if (state is AuthBlocStateDataRefresh) {
                // SchedulerBinding.instance.addPostFrameCallback((_) =>
                _initFunctions1(
                  state.url,
                  state.mapData,
                  state.headers,
                  state.onClickData,
                  state.serverError,
                  state.saveToLocal,
                  state.clearFromLocal,
                  state.previousClear,
                );
                // );
                // _initFunctions1(
                //     state.url,
                //     state.mapData,
                //     state.headers,
                //     state.onClickData,
                //     state.serverError,
                //     state.saveToLocal,
                //     state.previousClear);
              }
              if (state is AuthBlocStateEmailNotFound) {}
              if (state is AuthBlocStateLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is AuthBlocStateLoginSuccess) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast('Login Successful...');
                _router.push(
                  '/dynamic_form',
                  extra: {'token': '1', 'pageName': state.pageName},
                );
              } else if (state is AuthBlocStateRegisterSuccess) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast('Register Successful...');
                _router.push(
                  '/dynamic_form',
                  extra: {'token': '1', 'pageName': state.pageName},
                );
              } else if (state is AuthBlocStateRegisterWithOtpSuccess) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast('OTP send Successfully...');
                _router.push(
                  '/dynamic_form',
                  extra: {'token': '1', 'pageName': 'verify-otp'},
                );
              } else if (state is AuthBlocStateLoginWithOtpSuccess) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast('OTP send Successfully...');
                _router.push(
                  '/dynamic_form',
                  extra: {'token': '1', 'pageName': 'verify-otp'},
                );
              } else if (state is AuthBlocStateOtpVerified) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast('OTP verify Successfully...');
                _router.push(
                  '/dynamic_form',
                  extra: {'token': '1', 'pageName': state.pageName},
                );
              } else if (state is AuthBlocStateLogoutSuccess) {
                setState(() {
                  isLoading = false;
                });
                FirebaseMessaging.instance.unsubscribeFromTopic(general_topic);
                SharedPrefs().isLoggedIn = false;
                SharedPrefs.clearSharedPref();
                Navigator.pop(widget.context);
                Navigator.popUntil(widget.context, (route) => route.isFirst);
                _router.pushReplacement(
                  '/splash',
                  // extra: {'selectedIndex': 0},
                );
                EasyLoading.showToast('Logout Successfully...');
              } else if (state is AuthBlocStateCommonLogin) {
                setState(() {
                  isLoading = false;
                });
                // if (state.message
                //         .toString()
                //         .contains("OTP verified, login successful") ||
                //     state.message.toString().contains("Login successful")) {
                //   Navigator.popUntil(widget.context, (route) => route.isFirst);
                //   SharedPrefs().isLoggedIn = true;
                //   savePageData.clear();
                // }
                // EasyLoading.showToast(state.message.toString());
                if (state.onClickData?.pageIndex != null) {
                  utilOnPressed?[state.onClickData!.pageIndex!](
                      widget.formController.formData);
                  // widget.formController
                  //         .onPressed?[state.onClickData!.pageIndex!](
                  //     widget.formController.formData);
                } else {
                  if (state.pageName.isNotEmpty) {
                    if (dynamicPageName == dynamicPageNameString) {
                      handleNavigation(
                          state.pageName, state.onClickData, widget.context);
                      if (state.onClickData?.pageReplacement == true) {
                        _router.pushReplacement(
                          '/dynamic_form',
                          extra: {
                            'token': '1',
                            'pageName': state.pageName,
                            'onPressed': utilOnPressed,
                            'context': context,
                          },
                        );
                      } else {
                        _router.push(
                          '/dynamic_form',
                          extra: {
                            'token': '1',
                            'pageName': state.pageName,
                            'onPressed': utilOnPressed,
                            'context': context,
                          },
                        );
                      }
                    }
                  }
                }
              } else if (state is AuthBlocStateCommonSubmitData) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast(state.message.toString());
                if (state.pageName.isNotEmpty) {
                  handleNavigation(
                      state.pageName, state.onClickData, widget.context);
                  _router.push(
                    '/dynamic_form',
                    extra: {'token': '1', 'pageName': state.pageName},
                  );
                }
              } else if (state is AuthBlocStateCommonDeleteAccountData) {
                setState(() {
                  isLoading = false;
                });
                EasyLoading.showToast(state.message.toString());
                if (state.pageName.isNotEmpty) {
                  if (state.pageName == "splash") {
                    SharedPrefs.clearSharedPref();
                    savePageData.clear();
                    Navigator.popUntil(
                        widget.context, (route) => route.isFirst);
                    _router.pushReplacement(
                      '/splash',
                      // extra: {'selectedIndex': 0},
                    );
                  } else {
                    handleNavigation(
                        state.pageName, state.onClickData, widget.context);
                    _router.push(
                      '/dynamic_form',
                      extra: {'token': '1', 'pageName': state.pageName},
                    );
                  }
                }
              } else if (state is AuthBlocStateRegisterError) {
                setState(() {
                  isLoading = false;
                });
                // EasyLoading.showToast('Error - ${state.errorMessage.toString()}');
                if (dynamicPageName == dynamicPageNameString) {
                  DynamicPopupDialog.showPopupDialog(
                    model: DynamicPopupModel(
                      title: "Error",
                      content: state.serverError != null &&
                              state.serverError!.isNotEmpty
                          ? state.serverError
                          : state.errorMessage,
                      confirmButtonText: "OK",
                      // cancelButtonText: "No",
                      backgroundColor: Colors.white,
                      borderRadius: 10,
                    ),
                    formController: widget.formController,
                    context: widget.context,
                  );
                }
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: BlocListener<RefreshBloc, RefreshState>(
              listener: (context, state) {
                if (state is RefreshLoadedState) {
                  appBarWidgets.clear();
                  setState(() {
                    isPageLoad = true;
                    isLoading = false;
                  });
                  // SchedulerBinding.instance
                  //     .addPostFrameCallback((_) => _initFunctions());
                }
              },
              child: dynamicAppbarModel.title != null
                  ? Scaffold(
                      // appBar: DynamicAppbarController(
                      //     controller: dynamicAppbarModel, formController: formController),
                      appBar: DynamicAppbar(
                        controller: dynamicAppbarModel,
                        formWidgets: appBarWidgets,
                        formController: widget.formController,
                        onPressed: () {
                          if (dynamicAppbarModel
                                  .backImgUrl?.onClickData?.isBack ??
                              true) {
                            Navigator.pop(widget.context, true);
                            savePageData.removeLast();
                          } else {
                            var pageName = dynamicAppbarModel
                                .backImgUrl?.onClickData?.pageName;
                            if (pageName != null && pageName.isNotEmpty) {
                              widget.context.pop();
                              _router.push(
                                '/dynamic_form',
                                extra: {'token': '1', 'pageName': pageName},
                              );
                            }
                          }
                        },
                      ),
                      body: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              displacement:
                                  50.0, // Distance to drag before showing refresh
                              color: Colors.blue, // Progress indicator color
                              backgroundColor: Colors
                                  .white, // Background of refresh indicator
                              strokeWidth:
                                  3.0, // Thickness of the refresh indicator
                              child: formWidgets ?? Container()),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          SchedulerBinding.instance
                              .addPostFrameCallback((_) => _initFunctions());
                        },
                        child: const Icon(Icons.refresh),
                      ),
                    )
                  : Scaffold(
                      body: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              displacement:
                                  50.0, // Distance to drag before showing refresh
                              color: Colors.blue, // Progress indicator color
                              backgroundColor: Colors
                                  .white, // Background of refresh indicator
                              strokeWidth:
                                  3.0, // Thickness of the refresh indicator
                              child: formWidgets ?? Container()),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          SchedulerBinding.instance
                              .addPostFrameCallback((_) => _initFunctions());
                        },
                        child: const Icon(Icons.refresh),
                      ),
                    ),
            ));
    //   ),
    // );
  }
}
