import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_url.dart';
import 'package:tosspayments_widget_sdk_flutter/webview/payment_window_in_app_webview.dart';

import '../webview/javascript_channel.dart';

class RequestPaymentPage extends StatelessWidget {
  const RequestPaymentPage({super.key, required this.data, this.onFinish});

  final PaymentWidgetRequestData data;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TosspaymentsInAppWebviewState> webViewKey = GlobalKey();
    return Scaffold(
      body: SafeArea(
        child: TosspaymentsInAppWebview(
          key: webViewKey,
          onPageFinished: onFinish ?? () {},
          initialHtml: data.paymentHtml,
          handleOverrideUrl: (url) => handleOverrideUrl(context, url),
          domain: data.domain,
          baseJavascriptChannel: brandPayWebPageJavascriptChannels(context),
          gestureEnabled: true,
        ),
      ),
    );
  }

  Future<bool> handleOverrideUrl(
    BuildContext context,
    String? requestedUrl,
  ) async {
    if (requestedUrl == null) {
      return false;
    } else {
      Success? success = successFromUrl(requestedUrl);
      Fail? fail = failFromUrl(requestedUrl);
      bool isCanceled;
      try {
        isCanceled =
            Uri.parse(requestedUrl).queryParameters['code']?.toUpperCase() ==
            'PAY_PROCESSED_CANCELED';
      } catch (_) {
        isCanceled = false;
      }

      if (success != null) {
        Navigator.pop(context, success);
        return true;
      } else if (fail != null || isCanceled) {
        Navigator.pop(context, fail);
        return true;
      }

      final convertUrl = ConvertUrl(requestedUrl);

      final isHtml = requestedUrl.startsWith('data:text/html');
      final isNetworkUrl =
          convertUrl.appScheme == 'http' || convertUrl.appScheme == 'https';
      final isJavascriptUrl = requestedUrl.startsWith('javascript:');
      bool isIntent;
      try {
        isIntent = Uri.parse(requestedUrl).scheme == 'intent';
      } catch (_) {
        isIntent = false;
      }
      final isMarket =
          convertUrl.appScheme == 'market' ||
          convertUrl.appScheme == 'onestore';

      if (isHtml || isJavascriptUrl) {
        return false;
      } else if (isIntent || isMarket) {
        await convertUrl.launchApp();
        return true;
      } else if (isNetworkUrl) {
        if (Platform.isAndroid) {
          if (requestedUrl.startsWith('https://onesto.re') ||
              requestedUrl.startsWith('https://m.onestore')) {
            await convertUrl.launchApp();
            return true;
          }
        }
        return false;
      } else {
        await convertUrl.launchApp();
        return true;
      }
    }
  }

  Set<JavascriptChannel> brandPayWebPageJavascriptChannels(
    BuildContext context,
  ) => {
    JavascriptChannel(
      name: "evaluateJavascriptOnPaymentMethodWidget",
      onReceived: (jsonObject) async {
        Navigator.pop(context, jsonObject['script']);
      },
    ),
  };
}

class PaymentWidgetRequestData {
  final String paymentHtml;
  final String orderId;
  final String? domain;

  PaymentWidgetRequestData({
    required this.paymentHtml,
    required this.orderId,
    required this.domain,
  });
}
