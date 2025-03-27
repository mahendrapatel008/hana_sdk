import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_state.dart';
import 'package:hana_sdk/core/res/media_res.dart';
import 'package:hana_sdk/core/services/font_services.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/services/sizedbox_service.dart';
import 'package:hana_sdk/core/utils/constants.dart';
import 'package:hana_sdk/core/utils/device_utility.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initFbToken(context);
    // TDeviceUtils.setStatusBarColor(Colours.slpashBackground);
    TDeviceUtils.setStatusBarColor(Colors.transparent);
    print("SplashScreen:>>");
  }

  initFbToken(BuildContext context) async {
    await getAndroidId();
    await getDeviceInfo();

    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print("APNSToken:>>> $apnsToken");
    await FirebaseMessaging.instance.getToken().then((String? fcmToken) {
      SharedPrefs().fbToken = fcmToken;
      print("FirebaseToken:>>> $fcmToken");
    });
    // SharedPrefs().accessToken = "";
    // if (SharedPrefs().accessToken.isNotEmpty) {
    //   BlocProvider.of<AuthBloc>(context)
    //       .add(AuthBlocRefreshTokenEvent(mapData: {
    //     "appName": SharedPrefs().appName,
    //     "refreshToken": SharedPrefs().refreshToken,
    //   }));
    // } else {
    // SharedPrefs().accessToken =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNzI3NjgxNzI0NDc0Iiwicm9sZUlkIjoiMTcyNzY4MTcyNDE3MyIsImlhdCI6MTcyODU1NzE5MiwiZXhwIjoxNzI4NTYwNzkyfQ.qeegfNbKYmYvsM1jRhyda8pWsnjQBlbPeNEQIfZ8hpw";
    Timer(const Duration(seconds: 3), () {
      // SharedPrefs().appName = 'app8978545688887';
      // SharedPrefs().appRole = '1727195736894';
      // SharedPrefs().appModuleName = 'mobileappdesign';
      Navigator.popUntil(context, (route) => route.isFirst);
      context.pushReplacement(
        '/dynamic_form',
        extra: {'token': '2', 'pageName': 'app-login'},
      );
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthBlocStateTokenSuccess) {
          Timer(const Duration(seconds: 1), () async {
            await FirebaseMessaging.instance.subscribeToTopic(general_topic);
            // SharedPrefs().appName = 'app8978545688887';
            // SharedPrefs().appRole = '1727195736894';
            Navigator.popUntil(context, (route) => route.isFirst);
            context.pushReplacement(
              '/dynamic_form',
              extra: {'token': '2', 'pageName': 'app-login'},
            );
          });
        } else if (state is AuthBlocStateTokenError) {
          FirebaseMessaging.instance.unsubscribeFromTopic(general_topic);
          SharedPrefs().isLoggedIn = false;
          SharedPrefs.clearSharedPref();
          Navigator.pop(context);
          Navigator.popUntil(context, (route) => route.isFirst);
          context.pushReplacement(
            '/splash',
            // extra: {'selectedIndex': 0},
          );
          EasyLoading.showToast('Error - ${state.errorMessage.toString()}');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    MediaRes.splashLogo,
                  ),
                  SizedboxService.h10,
                  Text(
                    "HANA Platform",
                    style: FontService.custom(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
