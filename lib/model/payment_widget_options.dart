import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class PaymentWidgetOptions {
  final BrandPayOption? brandPayOption;

  PaymentWidgetOptions({this.brandPayOption});

  Map toJson() => {'brandPayOption': (brandPayOption != null) ? brandPayOption!.toJson() : null};
}

class BrandPayOption {
  final String redirectUrl;

  BrandPayOption(this.redirectUrl);

  Map toJson() => {'redirectUrl': redirectUrl};
}

enum Currency {
  KRW,
  AUD,
  EUR,
  GBP,
  HKD,
  JPY,
  SGD,
  USD;
}

class Amount {
  final num value;
  final Currency currency;
  String country;

  Amount({required this.value, this.currency = Currency.KRW, this.country = "KR"});

  Map toJson() => {
        'value': value,
        'currency': currency.name,
        'country': country,
      };
}

class RenderPaymentMethodsOptions {
  final String variantKey;

  RenderPaymentMethodsOptions({required this.variantKey});

  Map toJson() => {
        'variantKey': variantKey,
      };
}

class RenderAgreementOptions {
  final String variantKey;

  RenderAgreementOptions({required this.variantKey});

  Map toJson() => {
        'variantKey': variantKey,
      };
}

class PaymentMethodOptions {
  final PayPal? paypal;

  const PaymentMethodOptions({this.paypal});
}

class PayPal {
  final Object setTransactionContext;

  const PayPal({
    required this.setTransactionContext,
  });
}

class PaymentWidgetStatusListener {
  final void Function() onLoad;
  final void Function(Fail) onFail;

  const PaymentWidgetStatusListener({
    required this.onLoad,
    required this.onFail,
  });
}
