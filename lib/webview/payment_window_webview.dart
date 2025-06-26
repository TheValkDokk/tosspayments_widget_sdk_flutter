import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_url.dart';
import 'package:tosspayments_webview_flutter/tosspayments_webview_flutter.dart';

enum ActionType { auth, payment }

/// [TosspaymentsWebview] is a stateless widget that wraps WebView to enable
/// online payments using the Toss Payments API. It contains various callbacks
/// for handling JavaScript execution and payment success or failure.
class TosspaymentsWebview extends StatelessWidget {
  /// HTML string that is loaded into the WebView when the widget is built.
  static const String html = '''
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <script src="https://js.tosspayments.com/v1/payment"></script>
        <script type='text/javascript'>
          TosspaymentsReady.postMessage('');
        </script>
      </head>
      <body>      
      </body>
    </html>
  ''';

  /// Function to execute JavaScript in the WebView.
  final ValueSetter<WebViewController> executeJS;

  /// Function that is called when a payment is successful.
  final Function didSuccess;

  /// Function that is called when a payment fails.
  final Function didFail;

  late WebViewController _webViewController;

  /// Constructs a [TosspaymentsWebview] widget.
  TosspaymentsWebview(
      {super.key,
      required this.executeJS,
      required this.didSuccess,
      required this.didFail});

  /// Builds the [TosspaymentsWebview] widget and initializes the payment process.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          children: [
            WebView(
              initialUrl: Uri.dataFromString(TosspaymentsWebview.html,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString(),
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>{
                JavascriptChannel(
                    name: "TosspaymentsReady",
                    onMessageReceived: (JavascriptMessage message) {
                      executeJS(_webViewController);
                    })
              },
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              navigationDelegate: (request) async {
                // 웹뷰 화면 전환 시 실행
                //원천사 인증 완료시
                if (didSuccess(request.url)) {
                  return NavigationDecision.prevent;
                }

                if (didFail(request.url)) {
                  return NavigationDecision.prevent;
                }

                if (request.url.startsWith('intent')) {
                  return tossPaymentsWebview(request.url);
                }

                tossPaymentsWebview(request.url);

                return NavigationDecision.navigate;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Handles specific URL schemes (like 'intent') and launches the corresponding app if necessary.
/// [url] is the URL to be handled.
tossPaymentsWebview(url) {
  final convertUrl = ConvertUrl(url);

  // 앱링크일시 convert하기 위해
  if (convertUrl.isAppLink()) {
    convertUrl.launchApp();
    return NavigationDecision.prevent;
  }
}