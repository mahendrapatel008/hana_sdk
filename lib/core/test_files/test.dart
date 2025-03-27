// import 'dart:convert';
// import 'dart:io';

// import 'package:commune_app/core/comman_bloc/app_bloc/model/dynamic_data.dart';
// import 'package:commune_app/core/comman_bloc/app_bloc/model/dynamic_form.dart';
// import 'package:commune_app/core/comman_bloc/auth_bloc/auth_bloc.dart';
// import 'package:commune_app/core/comman_bloc/auth_bloc/auth_state.dart';
// import 'package:commune_app/core/comman_bloc/refresh_bloc/refresh_bloc.dart';
// import 'package:commune_app/core/comman_bloc/refresh_bloc/refresh_event.dart';
// import 'package:commune_app/core/comman_bloc/refresh_bloc/refresh_state.dart';
// import 'package:commune_app/core/controllers/api_element_controller.dart';
// import 'package:commune_app/core/controllers/api_elements_type_controller.dart';
// import 'package:commune_app/core/controllers/form_controller.dart';
// import 'package:commune_app/core/elements/dynamic_appbar/dynamic_appbar.dart';
// import 'package:commune_app/core/elements/dynamic_appbar/dynamic_appbar_model.dart';
// import 'package:commune_app/core/elements/dynamic_popup/dynamic_popup_dialog.dart';
// import 'package:commune_app/core/elements/dynamic_popup/dynamic_popup_model.dart';
// import 'package:commune_app/core/repo/repository.dart';
// import 'package:commune_app/core/services/shared_pref.dart';
// import 'package:commune_app/core/utils/constants.dart';
// import 'package:commune_app/core/utils/device_utility.dart';
// import 'package:commune_app/core/utils/utils_data.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// class DynamicFormScreen extends StatefulWidget {
//   final String token;
//   final String pageName;
//   final Map<String, dynamic>? listData;

//   const DynamicFormScreen({
//     super.key,
//     required this.token,
//     required this.pageName,
//     this.listData,
//   });

//   @override
//   State<DynamicFormScreen> createState() => _DynamicFormScreenState();
// }

// class _DynamicFormScreenState extends State<DynamicFormScreen> {
//   List<FormSectionMain> formSections = [];

//   Widget? formWidgets;
//   List<Widget> appBarWidgets = [];
//   bool isLoading = false;
//   bool isPageLoad = false;
//   DynamicAppbarModel dynamicAppbarModel = DynamicAppbarModel();
//   FormController formController = FormController();
//   String dynamicPageName = '';
//   String dynamicModuleName = '';
//   DynamicForm dynamicForm = DynamicForm(form: [], name: '');
//   String dynamicFormString = '';
//   DynamicData dynamicData = DynamicData(dynamicData: []);
// "dependentInvisibleFields" : {
//   "fieldName": ["VisibilityContainer",]
// }
//   Future<void> _initFunctions() async {
//     print("KJSJIJJ1");
//     setState(() {
//       isLoading = true;
//     });
//     formController = FormController();

//     // Check if shared preferences have data for the pageName
//     final sharedPrefData = SharedPrefs().getString(widget.pageName);
//     final sharedPrefDataQuery =
//         SharedPrefs().getString("${widget.pageName}query");
//     if (sharedPrefData != null) {
//       print("KJSJIJJ2");
//       // Parse shared preferences data and render immediately
//       dynamicForm =
//           DynamicForm.fromJson(sharedPrefData as Map<String, dynamic>);
//       if (sharedPrefDataQuery != null) {
//         dynamicData = (jsonDecode(sharedPrefDataQuery));
//       }
//       // if (dynamicForm.dynamicAppbar != null) {
//       //   dynamicAppbarModel = dynamicForm.dynamicAppbar!;
//       // }
//       dynamicPageName = '';
//       dynamicPageName = dynamicForm.name;
//       dynamicPageNameString = '';
//       dynamicPageNameString = dynamicForm.name;
//       if (savePageData.isNotEmpty) {
//         if (savePageData.last.toString() != dynamicForm.name) {
//           savePageData.add(dynamicForm.name);
//         }
//       } else {
//         savePageData.add(dynamicForm.name);
//       }
//       dynamicPageName = dynamicPageName;
//       formSections.addAll(dynamicForm.form);
//       // formWidgets.clear();
//       appBarWidgets.clear();
//       if (dynamicForm.dynamicAppbar != null) {
//         dynamicAppbarModel = dynamicForm.dynamicAppbar!;
//       }
//       setState(() {
//         isPageLoad = true;
//         isLoading = false;
//       });
//     }
//     _fetchAndUpdateDataInBackground();
//   }

//   Future<void> _fetchAndUpdateDataInBackground() async {
//     print("KJSJIJJ3");
//     ApiFormRepository apiFormRepository = ApiFormRepository();
//     // DynamicForm
//     dynamicForm = await apiFormRepository.getModuleData(
//         appName: widget.pageName == 'app-login'
//             ? 'app8978545688887'
//             : SharedPrefs().appName,
//         moduleName: widget.pageName == 'app-login'
//             ? 'mobileappdesign'
//             : SharedPrefs().appModuleName,
//         query: {"sectionData.mobilejson.name": widget.pageName},
//         limit: 100);
//     dynamicModuleName = dynamicForm.moduleName ?? "messege";
//     // DynamicData
//     if (widget.pageName != 'app-login' && dynamicForm.moduleName!.isNotEmpty) {
//       formController.clearFieldNameData();
//       savePrerequisitesNameData.clear();
//       // var indexedData = dynamicForm.dynamicLookup?[0];
//       formController.saveFieldNameLookUp(dynamicForm.dynamicLookup, null);
//       dynamicData = await apiFormRepository.getLookUpsModuleData(
//         appName: widget.pageName == 'app-login'
//             ? 'app8978545688887'
//             : SharedPrefs().appName,
//         moduleName: dynamicForm.moduleName ?? "message",
//         query: {},
//         limit: 100000000,
//         lookUps: dynamicForm.dynamicLookup ?? [],
//       );
//       formController.saveFieldNameData(
//           dynamicData.dynamicData[0] as Map<String, dynamic>, false);

//       if (dynamicData.dynamicData.contains('hanaDocumentId')) {
//         SharedPrefs().hanaDocumentId =
//             dynamicData.dynamicData[0]['hanaDocumentId'];
//       }
//     }
//     // if (dynamicForm.wantPreviousData == false) {
//     //   formController.formData.clear();
//     // }

//     // Compare with shared preferences data
//     final sharedPrefData = SharedPrefs().getString(widget.pageName);
//     // final sharedPrefDataQuery =
//     //     SharedPrefs().getString("${widget.pageName}appData");
//     if (sharedPrefData != null) {
//       print("KJSJIJJ4");
//       DynamicForm tempDynamicForm =
//           DynamicForm.fromJson(sharedPrefData as Map<String, dynamic>);
//       // List<FormSectionMain> savedFormSections =
//       //     (jsonDecode(sharedPrefData) as List)
//       //         .map((e) => FormSectionMain.fromJson(e))
//       //         .toList();
//       // DynamicAppbarModel savedDynamicForms = DynamicAppbarModel();
//       // if (sharedPrefDataQuery != null) {
//       //   savedDynamicForms = DynamicAppbarModel.fromJson(
//       //       sharedPrefDataQuery as Map<String, dynamic>);
//       // }

//       if (
//           // !_areFormSectionsSame(savedFormSections, dynamicForm.form) ||
//           !_areDynamicFormsSame(tempDynamicForm, dynamicForm)) {
//         print("KJSJIJJ5");
//         // If the data differs, update shared preferences
//         SharedPrefs().setString(widget.pageName, jsonEncode(dynamicForm));
//         SharedPrefs().setString("${widget.pageName}query",
//             jsonEncode(dynamicData.dynamicData[0] ?? ''));

//         // Update the UI with the new data
//         // setState(() {
//         //   formSections = dynamicForm.form;

//         //   isPageLoad = true; // Ensure this is rendered if needed
//         // });
//       }
//     } else {
//       print("KJSJIJJ6");
//       // Save to shared preferences if no data exists
//       SharedPrefs().setString(widget.pageName, jsonEncode(dynamicForm));
//       SharedPrefs().setString("${widget.pageName}query",
//           jsonEncode(dynamicData.dynamicData[0] ?? ''));

//       // Update the UI with the new data
//       // setState(() {
//       //   isLoading = false;
//       //   isPageLoad = true;
//       // });
//     }

//     dynamicPageName = '';
//     dynamicPageName = dynamicForm.name;
//     dynamicPageNameString = '';
//     dynamicPageNameString = dynamicForm.name;
//     if (savePageData.isNotEmpty) {
//       if (savePageData.last.toString() != dynamicForm.name) {
//         savePageData.add(dynamicForm.name);
//       }
//     } else {
//       savePageData.add(dynamicForm.name);
//     }
//     dynamicPageName = dynamicPageName;
//     formSections.addAll(dynamicForm.form);
//     // formWidgets.clear();
//     appBarWidgets.clear();
//     if (dynamicForm.dynamicAppbar != null) {
//       dynamicAppbarModel = dynamicForm.dynamicAppbar!;
//     }
//     setState(() {
//       isPageLoad = true;
//       isLoading = false;
//     });
//   }

//   bool _areFormSectionsSame(
//       List<FormSectionMain> form1, List<FormSectionMain> form2) {
//     try {
//       final json1 = jsonEncode(form1);
//       final json2 = jsonEncode(form2);
//       return json1 == json2;
//     } catch (e) {
//       return false;
//     }
//   }

//   bool _areDynamicFormsSame(DynamicForm form1, DynamicForm form2) {
//     try {
//       final json1 = jsonEncode(form1);
//       final json2 = jsonEncode(form2);
//       return json1 == json2;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> _initFunctions1(
//       List<dynamic>? queryData, bool? previousClear) async {
//     // If SharedPrefs().hanaDependent is not empty, replace 'hanaDependent' with its value in `queryData`
//     if (queryData != null && SharedPrefs().hanaDependent.isNotEmpty) {
//       queryData = queryData.map((item) {
//         if (item is Map<String, dynamic>) {
//           // Convert each item to JSON and replace "hanaDependent"
//           final jsonString = jsonEncode(item).replaceAll(
//               '"hanaDependent"', '"${SharedPrefs().hanaDependent}"');
//           return jsonDecode(jsonString); // Decode back to Map for further use
//         }
//         return item;
//       }).toList();
//     }
//     if (queryData != null) {
//       queryData = queryData.map((item) {
//         if (item is Map<String, dynamic>) {
//           // Convert each item to JSON and replace "hanaDependent"
//           final jsonString = jsonEncode(item).replaceAll(
//             '"hanaDateDependent"',
//             '"${SharedPrefs().hanaDateDependent.isNotEmpty ? SharedPrefs().hanaDateDependent : DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()}"',
//           );
//           return jsonDecode(jsonString); // Decode back to Map for further use
//         }
//         return item;
//       }).toList();
//     }
//     if (queryData != null) {
//       queryData = queryData.map((item) {
//         if (item is Map<String, dynamic>) {
//           // Convert each item to JSON and replace "hanaDependent"
//           final jsonString = jsonEncode(item).replaceAll(
//             '"hanaMonthDependent"',
//             '"${SharedPrefs().hanaMonthDependent.isNotEmpty ? SharedPrefs().hanaMonthDependent : DateFormat('MM-yyyy').format(DateTime.now()).toString()}"',
//           );
//           return jsonDecode(jsonString); // Decode back to Map for further use
//         }
//         return item;
//       }).toList();
//     }
//     if (queryData != null) {
//       queryData = queryData.map((item) {
//         if (item is Map<String, dynamic>) {
//           // Convert each item to JSON and replace "hanaDependent"
//           final jsonString = jsonEncode(item).replaceAll(
//             '"hanaYearDependent"',
//             '"${SharedPrefs().hanaYearDependent.isNotEmpty ? SharedPrefs().hanaYearDependent : DateFormat('yyyy').format(DateTime.now()).toString()}"',
//           );
//           return jsonDecode(jsonString); // Decode back to Map for further use
//         }
//         return item;
//       }).toList();
//     }
//     if (queryData != null && SharedPrefs().sId.isNotEmpty) {
//       queryData = queryData.map((item) {
//         if (item is Map<String, dynamic>) {
//           // Convert each item to JSON and replace "hanaDependent"
//           final jsonString = jsonEncode(item)
//               .replaceAll('"hanaUserId"', '"${SharedPrefs().sId}"');
//           return jsonDecode(jsonString); // Decode back to Map for further use
//         }
//         return item;
//       }).toList();
//     }

//     // Convert `queryData` to a JSON string using jsonEncode, which `jsonDecode` can parse correctly
//     String jsonLookups = jsonEncode(queryData);

//     // Decode the JSON string back to a Dart List
//     List<dynamic> jsonLookupData = jsonDecode(jsonLookups);

//     ApiFormRepository apiFormRepository = ApiFormRepository();

//     DynamicData dynamicData = await apiFormRepository.getLookUpsModuleData(
//       appName: widget.pageName == 'app-login'
//           ? 'app8978545688887'
//           : SharedPrefs().appName,
//       moduleName: dynamicModuleName,
//       query: {},
//       limit: 100000000,
//       lookUps: jsonLookupData,
//     );

//     formController.saveFieldNameData(
//         dynamicData.dynamicData[0] as Map<String, dynamic>, previousClear);
//     appBarWidgets.clear();
//     BlocProvider.of<RefreshBloc>(context).add(RefreshFormEvent(check: ''));
//   }

//   Future<void> _refresh() async {
//     SchedulerBinding.instance.addPostFrameCallback((_) => _initFunctions());
//   }

//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) => _initFunctions());
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<bool?> _showExitDialog(BuildContext context) async {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Exit App?'),
//         content: const Text('Do you want to exit the app?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () =>
//                 Navigator.of(context).pop(false), // Dismiss the dialog
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (TDeviceUtils.isAndroid()) {
//                 exit(0);
//               } else if (TDeviceUtils.isIOS()) {
//                 Navigator.of(context).pop(true);
//               }
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isPageLoad) {
//       isPageLoad = false;
//       for (var section in formSections) {
//         var formElement = ApiFormElements.fromJson({
//           "type": section.fields["type"],
//           "items": section.fields,
//         });
//         formElement.formController = formController;
//         var apiElementController =
//             ApiElementController(formSectionsElements: formElement);
//         formWidgets = apiElementController.buildFormElement();
//       }

//       if (dynamicAppbarModel.title != null) {
//         if (dynamicAppbarModel.items != null) {
//           if (dynamicAppbarModel.items!.isNotEmpty) {
//             var fields = dynamicAppbarModel.items;
//             for (var field in fields ?? []) {
//               var formElement = ApiFormElements.fromJson({
//                 "type": field['type'],
//                 "items": field,
//               });
//               formElement.formController = formController;
//               var apiElementController =
//                   ApiElementController(formSectionsElements: formElement);
//               appBarWidgets.add(apiElementController.buildFormElement());
//             }
//           }
//         }
//       }
//     }
//     return WillPopScope(
//       onWillPop: () async {
//         print("EasyLoading>>>>>>will$savePageData");
//         savePageData.removeLast();
//         dynamicPageNameString = savePageData[savePageData.length - 1];
//         Navigator.pop(context);
//         return true;
//       },
//       child: BlocListener<AuthBloc, AuthBlocState>(
//         listener: (context, state) {
//           if (state is AuthBlocStateDataRefresh) {
//             // SchedulerBinding.instance
//             //     .addPostFrameCallback((_) => _initFunctions(state.refresh));
//             print("njierers2");
//             _initFunctions1(state.refresh, state.previousClear);
//           }
//           if (state is AuthBlocStateEmailNotFound) {}
//           if (state is AuthBlocStateLoading) {
//             setState(() {
//               isLoading = true;
//             });
//           } else if (state is AuthBlocStateLoginSuccess) {
//             setState(() {
//               isLoading = false;
//             });
//             EasyLoading.showToast('Login Successful...');
//             context.push(
//               '/dynamic_form',
//               extra: {'token': '1', 'pageName': state.pageName},
//             );
//           } else if (state is AuthBlocStateRegisterSuccess) {
//             setState(() {
//               isLoading = false;
//             });
//             EasyLoading.showToast('Register Successful...');
//             context.push(
//               '/dynamic_form',
//               extra: {'token': '1', 'pageName': state.pageName},
//             );
//           } else if (state is AuthBlocStateRegisterWithOtpSuccess) {
//             setState(() {
//               isLoading = false;
//             });
//             EasyLoading.showToast('OTP send Successfully...');
//             context.push(
//               '/dynamic_form',
//               extra: {'token': '1', 'pageName': 'verify-otp'},
//             );
//           } else if (state is AuthBlocStateLoginWithOtpSuccess) {
//             setState(() {
//               isLoading = false;
//             });
//             EasyLoading.showToast('OTP send Successfully...');
//             context.push(
//               '/dynamic_form',
//               extra: {'token': '1', 'pageName': 'verify-otp'},
//             );
//           } else if (state is AuthBlocStateOtpVerified) {
//             setState(() {
//               isLoading = false;
//             });
//             EasyLoading.showToast('OTP verify Successfully...');
//             context.push(
//               '/dynamic_form',
//               extra: {'token': '1', 'pageName': state.pageName},
//             );
//           } else if (state is AuthBlocStateLogoutSuccess) {
//             setState(() {
//               isLoading = false;
//             });
//             FirebaseMessaging.instance.unsubscribeFromTopic(general_topic);
//             SharedPrefs().isLoggedIn = false;
//             SharedPrefs.clearSharedPref();
//             Navigator.pop(context);
//             Navigator.popUntil(context, (route) => route.isFirst);
//             context.pushReplacement(
//               '/splash',
//               // extra: {'selectedIndex': 0},
//             );
//             EasyLoading.showToast('Logout Successfully...');
//           } else if (state is AuthBlocStateCommonLogin) {
//             setState(() {
//               isLoading = false;
//             });
//             EasyLoading.showToast(state.message.toString());
//             if (state.pageName.isNotEmpty) {
//               if (dynamicPageName == dynamicPageNameString) {
//                 context.push(
//                   '/dynamic_form',
//                   extra: {'token': '1', 'pageName': state.pageName},
//                 );
//               }
//             }
//           } else if (state is AuthBlocStateRegisterError) {
//             setState(() {
//               isLoading = false;
//             });
//             // EasyLoading.showToast('Error - ${state.errorMessage.toString()}');
//             DynamicPopupDialog.showPopupDialog(
//               model: DynamicPopupModel(
//                 title: "Error",
//                 content: formController.validationErrors.values.join('\n'),
//                 confirmButtonText: "okey!",
//                 // cancelButtonText: "No",
//                 backgroundColor: Colors.white,
//                 borderRadius: 10,
//               ),
//               formController: formController,
//               context: context,
//             );
//           } else {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         },
//         child: BlocListener<RefreshBloc, RefreshState>(
//           listener: (context, state) {
//             if (state is RefreshLoadedState) {
//               appBarWidgets.clear();
//               setState(() {
//                 isPageLoad = true;
//                 isLoading = false;
//               });
//               // SchedulerBinding.instance
//               //     .addPostFrameCallback((_) => _initFunctions());
//             }
//           },
//           child: dynamicAppbarModel.title != null
//               ? Scaffold(
//                   // appBar: DynamicAppbarController(
//                   //     controller: dynamicAppbarModel, formController: formController),
//                   appBar: DynamicAppbar(
//                     controller: dynamicAppbarModel,
//                     formWidgets: appBarWidgets,
//                     formController: formController,
//                     onPressed: () {
//                       if (dynamicAppbarModel.backImgUrl?.onClickData?.isBack ??
//                           true) {
//                         context.pop();
//                       } else {
//                         var pageName = dynamicAppbarModel
//                             .backImgUrl?.onClickData?.pageName;
//                         if (pageName != null && pageName.isNotEmpty) {
//                           context.pop();
//                           context.push(
//                             '/dynamic_form',
//                             extra: {'token': '1', 'pageName': pageName},
//                           );
//                         }
//                       }
//                     },
//                   ),
//                   body: isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : RefreshIndicator(
//                           onRefresh: _refresh,
//                           displacement:
//                               50.0, // Distance to drag before showing refresh
//                           color: Colors.blue, // Progress indicator color
//                           backgroundColor:
//                               Colors.white, // Background of refresh indicator
//                           strokeWidth:
//                               3.0, // Thickness of the refresh indicator
//                           child: formWidgets ??
//                               SingleChildScrollView(
//                                 physics: AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                   height: MediaQuery.of(context).size.height,
//                                   alignment: Alignment.center,
//                                   child: const Text(
//                                     textAlign: TextAlign.center,
//                                     "The Page is Invalid.\nContact developer\nor\nPull down to refresh!",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         ),
//                   floatingActionButton: FloatingActionButton(
//                     onPressed: () {
//                       SchedulerBinding.instance
//                           .addPostFrameCallback((_) => _initFunctions());
//                     },
//                     child: const Icon(Icons.refresh),
//                   ),
//                 )
//               : Scaffold(
//                   body: isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : RefreshIndicator(
//                           onRefresh: _refresh,
//                           displacement:
//                               50.0, // Distance to drag before showing refresh
//                           color: Colors.blue, // Progress indicator color
//                           backgroundColor:
//                               Colors.white, // Background of refresh indicator
//                           strokeWidth:
//                               3.0, // Thickness of the refresh indicator
//                           child: formWidgets ??
//                               SingleChildScrollView(
//                                 physics: AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                   height: MediaQuery.of(context).size.height,
//                                   alignment: Alignment.center,
//                                   child: const Text(
//                                     textAlign: TextAlign.center,
//                                     "The Page is Invalid.\nContact developer\nor\nPull down to refresh!",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         ),
//                   floatingActionButton: FloatingActionButton(
//                     onPressed: () {
//                       SchedulerBinding.instance
//                           .addPostFrameCallback((_) => _initFunctions());
//                     },
//                     child: const Icon(Icons.refresh),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
