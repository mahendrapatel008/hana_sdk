import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hana_sdk/configs/api_config.dart';
import 'package:hana_sdk/core/Listeners/locationFetcherNotifier.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/api_data_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/auth_bloc/auth_event.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_bloc.dart';
import 'package:hana_sdk/core/res/colours.dart';
import 'package:hana_sdk/core/res/size_config.dart';
import 'package:hana_sdk/core/services/go_router_service.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/di/di.dart';
import 'package:hana_sdk/firebase_options.dart';
import 'package:hana_sdk/screens/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initSP();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await initDI();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()), // Provide AuthBloc here
        BlocProvider(create: (_) => FormBloc()),
        BlocProvider(create: (_) => RefreshBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _foregroundTimer;
  @override
  void initState() {
    super.initState();
    locationFetcherNotifier.addListener(() {
      if (locationFetcherNotifier.value) {
        startForegroundLocationFetching();
      } else {
        stopForegroundLocationFetching();
      }
    });
  }

  void startForegroundLocationFetching() {
    _foregroundTimer?.cancel(); // Cancel any existing timers
    _foregroundTimer =
        Timer.periodic(const Duration(minutes: 1), (timer) async {
      print("Foreground task: Location fetched via Timer");
      var position = await fetchAndSendLocation(); // Await the async function
      BlocProvider.of<AuthBloc>(context).add(
        AuthBlocCommonLocationFetcherEvent(mapData: {
          "_id": SharedPrefs().attendenceId.toString(),
          "location": [
            {
              "latitude": "${position?.latitude.toString()}",
              "longitude": "${position?.longitude.toString()}"
            }
          ],
          "database": SharedPrefs().locationDatabase
        }),
      );
    });
  }

  Future<Position?> fetchAndSendLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied.");
        return null;
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      return position;
    } catch (e) {
      print("Error fetching location: $e");
      return null;
    }
  }

  void stopForegroundLocationFetching() {
    _foregroundTimer?.cancel();
    print("Foreground location fetching stopped.");
  }

  @override
  void dispose() {
    _foregroundTimer?.cancel();
    locationFetcherNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = getRouter(home: SplashScreen());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ApiConfig();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SizeConfig().init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FormBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => RefreshBloc()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Dynamic Form App',
          theme: ThemeData(
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              backgroundColor: Colors.white,
              scrolledUnderElevation: 50,
              surfaceTintColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black, size: 24),
              actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
              titleTextStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            primaryColor: Colours.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins',
          ),
          routerConfig: router,
          builder: EasyLoading.init(
            builder: (ctx, child) {
              EasyLoadingStyle.custom;
              EasyLoading.instance
                ..displayDuration = const Duration(milliseconds: 1000)
                // ..backgroundColor = Colors.red
                ..indicatorColor = Colors.red
                ..maskColor = Colors.red
                ..userInteractions = false;
              // ScreenUtil.init(ctx);
              return child!;
            },
          ),
        ),
      ),
    );
  }
}
