import 'package:go_router/go_router.dart';
import 'package:hana_sdk/screens/dynamic_form_page/dynamic_page.dart';
import 'package:hana_sdk/screens/splash_screen/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'splash',
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: 'dynamic_form',
          builder: (context, state) {
            Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
            return DynamicFormScreen(
              token: extra['token'],
              pageName: extra['pageName'],
              listData: extra['listData'],
              isFromList: extra['isFromList'],
            );
          },
        ),
      ],
    ),
  ],
);
