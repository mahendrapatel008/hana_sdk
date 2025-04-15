import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/screens/dynamic_form_page/dynamic_page.dart';

GoRouter getRouter({required Widget home}) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => home,
        routes: <RouteBase>[
          GoRoute(
            path: 'splash',
            builder: (context, state) => home,
          ),
          GoRoute(
            path: 'dynamic_form',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return DynamicFormScreen(
                formController: extra['formController'] ?? FormController(),
                token: extra['token'] ?? '',
                appName: extra['appName'] ?? '',
                pageName: extra['pageName'] ?? '',
                listData: extra['listData'],
                isFromList: extra['isFromList'],
                onPressed: extra['onPressed'],
                context: extra['context'],
              );
            },
          ),
        ],
      ),
    ],
  );
}
