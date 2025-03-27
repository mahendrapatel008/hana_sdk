import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_webview/dynamic_webview_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DynamicWebView extends StatefulWidget {
  final DynamicWebViewModel model;
  final FormController formController;

  const DynamicWebView(
      {super.key, required this.model, required this.formController});

  @override
  State<DynamicWebView> createState() => _DynamicWebViewState();
}

class _DynamicWebViewState extends State<DynamicWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Handle loading progress
        },
        onPageStarted: (String url) {
          // If the URL changes, check if it matches a specific condition to pop
          if (_shouldPopOnUrlChange(url)) {
            context.pop();
          }
        },
        onPageFinished: (String url) {
          // Optionally handle after the page is fully loaded
        },
        onHttpError: (HttpResponseError error) {
          // Handle HTTP error
        },
        onWebResourceError: (WebResourceError error) {
          // Handle web resource error
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent; // Prevent navigation to YouTube
          }
          return NavigationDecision.navigate; // Allow all other navigation
        },
      ));
  }

  bool _shouldPopOnUrlChange(String url) {
    // Define the condition to pop the view
    // Example: Pop if the URL contains a specific keyword or matches a pattern
    return url.contains('success') || url.contains('completed');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: resolveDynamicValue(widget.model.dataKey,
            widget.model.initialUrl, widget.formController),
        builder: (context, snapshot) {
          final resolvedText =
              snapshot.data ?? widget.model.initialUrl ?? '...';
          controller.loadRequest(Uri.parse(resolvedText));
          // loadUrlIfAvailable(); // Attempt to load the URL if dynamic data is available
          return WebViewWidget(controller: controller);
        });
  }
}
