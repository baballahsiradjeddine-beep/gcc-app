import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutWebView extends ConsumerStatefulWidget {
  final String checkoutUrl;

  const CheckoutWebView({super.key, required this.checkoutUrl});

  @override
  ConsumerState<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends ConsumerState<CheckoutWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            AppLogger.logInfo("Started loading: $url");
          },
          onPageFinished: (url) {
            // debugPrint("Finished: $url");
            AppLogger.logInfo("Finished loading: $url");
          },
          onNavigationRequest: (request) {
            AppLogger.logInfo('Navigating to: ${request.url}');
            if (request.url.contains("success")) {
              AppLogger.logInfo('Payment successful, URL: ${request.url}');
              // ref.read(chargilyControllerProvider.notifier).setResponse(
              //       ChargilyResponse.success,
              //     );
              context.pop(true);
              return NavigationDecision.prevent;
            } else if (request.url.contains("failure") ||
                request.url.contains("failed")) {
              // ref.read(chargilyControllerProvider.notifier).setResponse(
              //       ChargilyResponse.failure,
              //     );
              AppLogger.logInfo('Payment failed, URL: ${request.url}');
              context.pop(false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الدفع"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop(false);
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
