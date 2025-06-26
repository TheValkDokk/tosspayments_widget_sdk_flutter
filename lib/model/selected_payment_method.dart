class SelectedPaymentMethod {
  final String type;
  final String? method;
  final EasyPay? easyPay;
  final Transfer? transfer;
  final String? paymentMethodKey;
  final String? methodId;

  const SelectedPaymentMethod(
      {required this.type,
      this.method,
      this.easyPay,
      this.transfer,
      this.paymentMethodKey,
      this.methodId});

  static SelectedPaymentMethod fromJson(params) {
    String type = params['type'];
    String? method = params['method'];

    String? easyPayProvider = params['easyPay']?['provider'];
    EasyPay? easyPay =
        (easyPayProvider != null) ? EasyPay(provider: easyPayProvider) : null;

    String? transferProvider = params['transfer']?['provider'];
    Transfer? transfer = (transferProvider != null)
        ? Transfer(provider: transferProvider)
        : null;

    String? paymentMethodKey = params['paymentMethodKey'];
    String? methodId = params['methodId'];

    return SelectedPaymentMethod(
        type: type,
        method: method,
        easyPay: easyPay,
        transfer: transfer,
        paymentMethodKey: paymentMethodKey,
        methodId: methodId);
  }
}

class EasyPay {
  final String? provider;

  const EasyPay({
    this.provider,
  });
}

class Transfer {
  final String? provider;

  const Transfer({this.provider});
}
