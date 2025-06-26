import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/widget_container.dart';

/// 토스페이먼츠 결제위젯입니다.
/// [clientKey] : API 키 메뉴에서 확인할 수 있는 클라이언트 키 입니다.
/// [customerKey] : 고객 ID입니다. 충분히 무작위한 고유 값을 넣어야 합니다.
/// [paymentWidgetOptions] : 결제위젯 옵션입니다.
class PaymentWidget {
  final String clientKey;
  final String customerKey;
  final PaymentWidgetOptions? paymentWidgetOptions;

  PaymentWidget({
    required this.clientKey,
    required this.customerKey,
    this.paymentWidgetOptions,
  });

  /// 결제수단 위젯을 렌더링하는 메서드입니다.
  /// [selector] : 렌더링할 위젯의 식별자입니다. UI 트리에 추가한 [PaymentMethodWidget]의 생성자에 넣은 값을 입력합니다.
  /// [amount] : 결제 금액 정보입니다. (금액, 통화, 국가)
  /// [options] : 결제수단 위젯의 렌더링 옵션입니다.
  /// UI 트리에 [selector]을 갖는 [PaymentMethodWidget]이 없는 경우 [Exception]을 발생시킵니다.
  /// 정상적으로 렌더링되면 [PaymentMethodWidgetControl]의 Future를 반환합니다.
  Future<PaymentMethodWidgetControl> renderPaymentMethods({
    required String selector,
    required Amount amount,
    RenderPaymentMethodsOptions? options,
  }) {
    final completer = Completer<PaymentMethodWidgetControl>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final paymentMethodKey = _widgetKeyMap[selector];
      if (paymentMethodKey is! GlobalKey<PaymentMethodWidgetState>) {
        throw Exception('PaymentMethodWidget with selector \'$selector\' does not exist.');
      }
      (paymentMethodKey.currentState?.renderPaymentMethods(
                amount: amount,
                options: options,
              ) ??
              (throw Exception('PaymentMethod is not rendered. Call \'renderPaymentMethods\' method first.')))
          .then((value) {
        completer.complete(value);
      }, onError: (e) {
        completer.completeError(e);
      });
    });
    return completer.future;
  }

  /// 결제 약관 UI를 렌더링하는 메서드입니다.
  /// [selector] : 렌더링할 위젯의 식별자입니다. UI 트리에 추가한 [AgreementWidget]의 생성자에 넣은 값을 입력합니다.
  /// [options] : 약관 위젯의 렌더링 옵션입니다.
  /// UI 트리에 [selector]을 갖는 [AgreementWidget]이 없는 경우 [Exception] 을 발생시킵니다.
  /// 정상적으로 렌더링되면 [AgreementWidgetControl]의 Future를 반환합니다.
  Future<AgreementWidgetControl> renderAgreement({
    required String selector,
    RenderAgreementOptions? options,
  }) {
    final completer = Completer<AgreementWidgetControl>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final paymentAgreementKey = _widgetKeyMap[selector];
      if (paymentAgreementKey is! GlobalKey<PaymentAgreementWidgetState>) {
        throw Exception('AgreementWidget with selector \'$selector\' does not exist.');
      }
      (paymentAgreementKey.currentState?.renderAgreement(options: options) ??
              (throw Exception('Agreement is not rendered. Call \'renderAgreement\' method first.')))
          .then((value) {
        completer.complete(value);
      }, onError: (e) {
        completer.completeError(e);
      });
    });
    return completer.future;
  }

  /// 선택한 결제수단의 결제창을 띄우는 메서드입니다.
  /// [paymentInfo] : 결제 정보입니다.
  /// 정상적으로 [PaymentMethodWidget]이 렌더링되지 않았을 경우 [Exception]을 발생시킵니다.
  /// 결제 성공 여부에 따라 [Result]의 Future를 반환합니다.
  Future<Result> requestPayment({required PaymentInfo paymentInfo}) async {
    try {
      final paymentMethodKey =
          _widgetKeyMap.values.firstWhere((element) => element is GlobalKey<PaymentMethodWidgetState>)
              as GlobalKey<PaymentMethodWidgetState>;
      return await paymentMethodKey.currentState?.requestPayment(paymentInfo: paymentInfo) ??
          (throw Exception('PaymentMethod is not rendered. Call \'renderPaymentMethods\' method first.'));
    } catch (_) {
      throw Exception('PaymentMethod is not rendered. Call \'renderPaymentMethods\' method first.');
    }
  }

  final Map<String, GlobalKey<WidgetContainerState>> _widgetKeyMap = {};

  GlobalKey<T> getGlobalKey<T extends WidgetContainerState>(String selector) {
    final areYouThere = _widgetKeyMap[selector];
    if (areYouThere == null || areYouThere is! GlobalKey<T>) {
      final newKey = GlobalKey<T>();
      _widgetKeyMap[selector] = newKey;
      return newKey;
    } else {
      return areYouThere;
    }
  }

  static const anonymous = '@@ANONYMOUS';
}
