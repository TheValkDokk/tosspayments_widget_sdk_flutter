import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';
import 'package:tosspayments_widget_sdk_flutter/webview/payment_window_webview.dart';
import 'package:tosspayments_webview_flutter/tosspayments_webview_flutter.dart';

import '../model/tosspayments_url.dart';

/// [TossPayments] is a widget that wraps TosspaymentsWebview to enable
/// online payments using the Toss Payments API. It requires a client key,
/// payment data, and callbacks for success and failure.
class TossPayments extends StatelessWidget {
  /// [clientKey] is a required parameter that is used for authentication with the Toss Payments API.
  /// [data] represents the payment information necessary for the transaction.
  /// [success] is a callback that will be called when a payment is successfully made.
  /// [fail] is a callback that will be called when a payment fails.
  final String clientKey;
  final PaymentData data;
  final success;
  final fail;

  const TossPayments(
      {Key? key,
      required this.clientKey,
      required this.data,
      required this.success,
      required this.fail})
      : super(key: key);

  /// Builds the TossPayments widget and initializes the payment process.
  @override
  Widget build(BuildContext context) {
    return TosspaymentsWebview(executeJS: (WebViewController controller) {
      controller.evaluateJavascript('''
          var clientKey = '$clientKey';
          var tossPayments = TossPayments(clientKey);
          tossPayments.requestPayment('${data.paymentMethod}', ${jsonEncode(data.toJson())});
          ''');
    }, didSuccess: (String url) {
      final Success? result = successFromUrl(url);
      if (result != null) {
        success(result);
        return true;
      }
      return false;
    }, didFail: (String url) {
      final Fail? result = failFromUrl(url);
      if (result != null) {
        fail(result);
        return true;
      }
      return false;
    });
  }
}
