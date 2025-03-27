import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/configs/api_config.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_event.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/elements/dynamic_popup_button/dynamic_popup_button_model.dart';
import 'package:hana_sdk/core/model/on_click_data.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicPopupMenuButton extends StatefulWidget {
  final DynamicPopupMenuModel controller;
  final FormController formController;
  final Widget formWidgets;

  const DynamicPopupMenuButton(
      {super.key,
      required this.formController,
      required this.controller,
      required this.formWidgets});

  @override
  State<DynamicPopupMenuButton> createState() => _DynamicPopupMenuButtonState();
}

class _DynamicPopupMenuButtonState extends State<DynamicPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) {
        return List.generate(widget.controller.popupMenuItems?.length ?? 0,
            (index) {
          return PopupMenuItem<int>(
            onTap: () => onItemSelected(index),
            value: index,
            child: Row(
              children: [
                // Use a SizedBox to constrain the leading widget
                widget.controller.popupMenuItems?[index].imgUrl != null
                    ? SizedBox(
                        width: widget.controller.width ?? 40,
                        height: widget.controller.height ?? 40,
                        child: Image.network(
                          widget.controller.popupMenuItems?[index].imgUrl ?? '',
                          fit: widget.controller.fit,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.controller.popupMenuItems?[index].label ?? '',
                        style: TextStyle(
                          fontWeight: stringToFontWeight(
                              widget.controller.fontWeightLabel ?? 'normal'),
                          fontSize:
                              widget.controller.fontSizeLabel?.toDouble() ??
                                  14.0,
                          color: hexToColor(
                              widget.controller.textColorLabel ?? '#000000'),
                        ),
                      ),
                      if (widget.controller.popupMenuItems?[index].subtitle !=
                          null)
                        Text(
                          widget.controller.popupMenuItems?[index].subtitle ??
                              '',
                          style: TextStyle(
                            fontWeight: stringToFontWeight(
                                widget.controller.fontWeightSublabel ??
                                    'normal'),
                            fontSize: widget.controller.fontSizeSublabel
                                    ?.toDouble() ??
                                14.0,
                            color: hexToColor(
                                widget.controller.textColorSublabel ??
                                    '#000000'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
      child: widget.formWidgets, // Icon to trigger the popup
    );
  }

  void onItemSelected(int index) {
    if (index < 0 || index >= (widget.controller.popupMenuItems?.length ?? 1)) {
      return;
    }

    final selectedItem = widget.controller.popupMenuItems?[index];

    // Check if onClickData is available
    if (selectedItem?.onClickData != null) {
      String? apiName = selectedItem?.onClickData?.apiName;
      String? pageName = selectedItem?.onClickData?.pageName;
      // Call the respective API or navigate based on the action
      if (apiName != null && apiName.isNotEmpty) {
        handleApiAction(apiName, pageName, selectedItem?.onClickData);
      } else {
        // Navigate to a different page
        if (apiName != null && pageName!.isNotEmpty) {
          context.push('/dynamic_form',
              extra: {'token': '1', 'pageName': pageName});
        }
      }
    }
  }

  void handleApiAction(
      String apiName, String? pageName, OnClickData? onClickData) {
    if (apiName == 'google') {
      BlocProvider.of<AuthBloc>(context).add(AuthBlocGoogleLoginEvent(
        mapData: const {},
        pageName: pageName,
        serverError: onClickData?.serverError,
      ));
    } else if (apiName == 'resend-otp') {
      BlocProvider.of<AuthBloc>(context).add(AuthBlocCommonLoginEvent(
        serverError: onClickData?.serverError,
        onClickData: onClickData,
        mapData: {
          "appName": SharedPrefs().appName,
          "username": SharedPrefs().userName,
          "role": SharedPrefs().appRole,
        },
        pageName: '',
        apiName: ApiConfig.loginWithOtp,
      ));
    } else if (apiName == 'verify-otp') {
      BlocProvider.of<AuthBloc>(context).add(AuthBlocCommonLoginEvent(
        serverError: onClickData?.serverError,
        onClickData: onClickData,
        mapData: {
          "appName": SharedPrefs().appName,
          "type": "email",
          "username": SharedPrefs().userName,
          "otp": widget.formController.otpData,
        },
        pageName: pageName ?? '',
        apiName: ApiConfig.verifyOtp,
      ));
    } else {
      // Additional API actions can be added here
      // Example for default action:
      BlocProvider.of<AuthBloc>(context).add(AuthBlocCommonLoginEvent(
        serverError: onClickData?.serverError,
        onClickData: onClickData,
        pageName: pageName ?? '',
        apiName: apiName,
        mapData: widget.formController.formData,
      ));
    }
  }
}
