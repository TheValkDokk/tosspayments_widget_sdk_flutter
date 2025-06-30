import 'dart:convert';

import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/utils/navigate.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/widget_container.dart';

import '../model/payment_widget_options.dart';
import '../model/selected_payment_method.dart';
import '../model/tosspayments_result.dart';
import '../pages/payment_request_page.dart';
import '../webview/javascript_channel.dart';

class PaymentMethodWidget extends WidgetContainer {
  final void Function(String)? onCustomRequested;
  final void Function(String)? onCustomPaymentMethodSelected;
  final void Function(String)? onCustomPaymentMethodUnselected;
  @override
  final void Function()? onFinish;

  PaymentMethodWidget({
    required PaymentWidget paymentWidget,
    required String selector,
    this.onCustomRequested,
    this.onCustomPaymentMethodSelected,
    this.onCustomPaymentMethodUnselected,
    this.onFinish,
  }) : super(
         key: paymentWidget.getGlobalKey<PaymentMethodWidgetState>(selector),
         paymentWidget: paymentWidget,
         onFinish: onFinish,
       );

  @override
  WidgetContainerState createState() => PaymentMethodWidgetState();
}

class PaymentMethodWidgetState extends WidgetContainerState {
  Amount? amount;
  var requestPaymentInProgress = false;

  void onFinish() {
    (widget as PaymentMethodWidget).onFinish?.call();
  }

  Future<PaymentMethodWidgetControl> renderPaymentMethods({
    required Amount amount,
    RenderPaymentMethodsOptions? options,
  }) async {
    addJavascriptChannels(_methodWidgetJavascriptChannels);
    this.amount = amount;

    final amountJson = jsonEncode(amount.toJson());
    final optionsJson = jsonEncode(options?.toJson() ?? '');

    String renderScript =
        'const paymentMethodWidget = paymentWidget.renderPaymentMethods(\'#payment-method\', $amountJson, $optionsJson);';
    try {
      await renderWidget(renderScript: renderScript);
      return PaymentMethodWidgetControl._(
        updateAmount: _updateAmount,
        getSelectedPaymentMethod: _getSelectedPaymentMethod,
      );
    } catch (fail) {
      return Future.error(fail);
    }
  }

  Future<dynamic> requestPayment({required PaymentInfo paymentInfo}) async {
    orderId = paymentInfo.orderId;

    Map<String, dynamic> payload = paymentInfo.toJson();
    payload['amount'] = amount;
    payload['successUrl'] = 'tosspayments://payment/flutter/success';
    payload['failUrl'] = 'tosspayments://payment/flutter/fail';
    if (paymentInfo.mockPaymentResult != MockPaymentResult.none) {
      payload['_skipAuth'] = paymentInfo.mockPaymentResult.name;
    }
    return evaluateJavascriptFuture(
      "paymentWidget.requestPaymentForNativeSDK(${jsonEncode(payload)})",
      'payment',
    );
  }

  Future<void> _updateAmount({required num amount}) async {
    await evaluateJavascriptWithResolve(
      'paymentMethodWidget.updateAmount($amount)',
    );
  }

  Future<SelectedPaymentMethod> _getSelectedPaymentMethod() async {
    return SelectedPaymentMethod.fromJson(
      await evaluateJavascriptWithResolve(
        'paymentMethodWidget.getSelectedPaymentMethod()',
      ),
    );
  }

  Set<JavascriptChannel> get _methodWidgetJavascriptChannels => {
    JavascriptChannel(
      name: "requestPayments",
      onReceived: (jsonObject) async {
        var paymentHtml = jsonObject['html'];

        if (requestPaymentInProgress) return;
        requestPaymentInProgress = true;
        var result = await navigateToWebviewByPlatform(
          context,
          RequestPaymentPage(
            onFinish: onFinish,
            data: PaymentWidgetRequestData(
              paymentHtml: paymentHtml,
              orderId: orderId,
              domain: domain,
            ),
          ),
        );
        if (result != null) {
          if (result.runtimeType == Success) {
            eventManager.triggerEvent('payment', Result(success: result));
          } else if (result.runtimeType == Fail) {
            eventManager.triggerEvent('payment', Result(fail: result));
          }
        } else {
          // 하드웨어 백버튼 or 모달 드래그해서 닫은 경우
          eventManager.triggerEvent(
            'payment',
            Result(
              fail: Fail("PAY_PROCESS_CANCELED", "사용자가 결제를 취소하였습니다", orderId),
            ),
          );
        }
        requestPaymentInProgress = false;
      },
    ),
    JavascriptChannel(
      name: "error",
      onReceived: (jsonObject) {
        String errorCode = jsonObject['errorCode'] ?? '';
        String errorMessage = jsonObject['errorMessage'] ?? '';
        String orderId = jsonObject['orderId'] ?? '';
        eventManager.triggerError(
          'widgetStatus',
          Fail(errorCode, errorMessage, orderId),
        );
        eventManager.triggerEvent(
          'payment',
          Result(fail: Fail(errorCode, errorMessage, orderId)),
        );
      },
    ),
    JavascriptChannel(
      name: "customRequest",
      onReceived: (jsonObject) {
        var paymentMethodKey = jsonObject['paymentMethodKey'];
        (widget as PaymentMethodWidget).onCustomRequested?.call(
          paymentMethodKey,
        );
      },
    ),
    JavascriptChannel(
      name: "customPaymentMethodSelect",
      onReceived: (jsonObject) {
        var paymentMethodKey = jsonObject['paymentMethodKey'];
        (widget as PaymentMethodWidget).onCustomPaymentMethodSelected?.call(
          paymentMethodKey,
        );
      },
    ),
    JavascriptChannel(
      name: "customPaymentMethodUnselect",
      onReceived: (jsonObject) {
        var paymentMethodKey = jsonObject['paymentMethodKey'];
        (widget as PaymentMethodWidget).onCustomPaymentMethodUnselected?.call(
          paymentMethodKey,
        );
      },
    ),
    JavascriptChannel(
      name: "changePaymentMethod",
      onReceived: (jsonObject) {
        // var params = json.decode(message.message)['params'];
        // eventManager.triggerEvent('changePaymentMethod', event)
        // selectedPaymentMethod = SelectedPaymentMethod.fromJson(params);
      },
    ),
    JavascriptChannel(
      name: "requestHTML",
      onReceived: (jsonObject) async {
        var brandPayHTML = jsonObject['html'];

        if (requestPaymentInProgress) return;
        requestPaymentInProgress = true;
        var result = await navigateToWebviewByPlatform(
          context,
          RequestPaymentPage(
            onFinish: onFinish,
            data: PaymentWidgetRequestData(
              paymentHtml: brandPayHTML,
              orderId: orderId,
              domain: domain,
            ),
          ),
        );
        if (result != null) {
          if (result.runtimeType == String) {
            evaluateJavascript(result);
          }
        }
        requestPaymentInProgress = false;
      },
    ),
  };

  @override
  void initState() {
    super.initState();
    eventManager.addEvent('payment');
  }
}

/// [renderPaymentMethod]로 얻을 수 있는 클래스입니다.
/// [updateAmount] : 결제 금액을 변경합니다. 변경된 금액에 따라 UI도 업데이트 됩니다(할부 적용, 즉시할인 적용).
/// [getSelectedPaymentMethod] : 고객이 선택한 결제수단을 반환합니다.
class PaymentMethodWidgetControl {
  final Future<void> Function({required num amount}) updateAmount;
  final Future<SelectedPaymentMethod> Function() getSelectedPaymentMethod;

  PaymentMethodWidgetControl._({
    required this.updateAmount,
    required this.getSelectedPaymentMethod,
  });
}
