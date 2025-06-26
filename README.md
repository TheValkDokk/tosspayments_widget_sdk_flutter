Flutter에서 토스페이먼츠 결제위젯을 손쉽게 연동하기 위한 패키지입니다.

## 1. 사전 설정

### 요구 사항
- Flutter 3.7.0 이상
- Dart SDK 2.17.0 이상
- Android minSdkVersion 19 이상

### A. 패키지 다운로드
pubspec.yaml에 패키지 추가 
```xml
dependencies:
tosspayments_widget_sdk_flutter: ^2.1.1
```

### B. Android 설정
인터넷 권한을 부여하고, usesCleartextTraffic 세팅을 true로 설정하여 웹뷰 내 모든 카드사앱을 띄울 수 있도록 설정
```xml
<!-- android/app/main/AndroidManifest.xml -->
    ...
    <uses-permission android:name="android.permission.INTERNET" />
    <appication
        ...
        android:usesCleartextTraffic="true">
    </application>
    ...
```

## 2. 시작하기
아래 방법으로 토스페이먼츠 결제 위젯을 띄울 수 있습니다. 자세한 내용은 예제(example)을 참고해 주세요.

```dart
import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaymentWidgetExamplePage(),
    );
  }
}

class PaymentWidgetExamplePage extends StatefulWidget {
  const PaymentWidgetExamplePage({super.key});

  @override
  State<PaymentWidgetExamplePage> createState() {
    return _PaymentWidgetExamplePageState();
  }
}

class _PaymentWidgetExamplePageState extends State<PaymentWidgetExamplePage> {
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;

  @override
  void initState() {
    super.initState();

    _paymentWidget = PaymentWidget(clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm", customerKey: "a1b2c3d4e5f67890");

    _paymentWidget
        .renderPaymentMethods(
        selector: 'methods',
        amount: Amount(value: 300, currency: Currency.KRW, country: "KR"))
        .then((control) {
      _paymentMethodWidgetControl = control;
    });

    _paymentWidget
        .renderAgreement(selector: 'agreement')
        .then((control) {
      _agreementWidgetControl = control;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
              Expanded(
                  child: ListView(children: [
                    PaymentMethodWidget(
                      paymentWidget: _paymentWidget,
                      selector: 'methods',
                    ),
                    AgreementWidget(paymentWidget: _paymentWidget, selector: 'agreement'),
                    ElevatedButton(
                        onPressed: () async {
                          final paymentResult = await _paymentWidget.requestPayment(
                              paymentInfo: const PaymentInfo(orderId: 'OrderId_123', orderName: '파란티셔츠 외 2건'));
                          if (paymentResult.success != null) {
                            // 결제 성공 처리
                          } else if (paymentResult.fail != null) {
                            // 결제 실패 처리
                          }
                        },
                        child: const Text('결제하기')),
                    ElevatedButton(
                        onPressed: () async {
                          final selectedPaymentMethod = await _paymentMethodWidgetControl?.getSelectedPaymentMethod();
                          print('${selectedPaymentMethod?.method} ${selectedPaymentMethod?.easyPay?.provider ?? ''}');
                        },
                        child: const Text('선택한 결제수단 출력')),
                    ElevatedButton(
                        onPressed: () async {
                          final agreementStatus = await _agreementWidgetControl?.getAgreementStatus();
                          print('${agreementStatus?.agreedRequiredTerms}');
                        },
                        child: const Text('약관 동의 상태 출력')),
                    ElevatedButton(
                        onPressed: () async {
                          await _paymentMethodWidgetControl?.updateAmount(amount: 300);
                          print('결제 금액이 300원으로 변경되었습니다.');
                        },
                        child: const Text('결제 금액 변경'))
                  ]))
            ])));
  }
}
```
## * 연동 관련 문의사항
 디스코드로 찾아오시면 실시간 채팅으로 궁금한 점을 해결하실 수 있습니다. ([디스코드 링크](https://discord.gg/tosspayments)) 
