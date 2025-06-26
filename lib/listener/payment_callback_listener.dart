import '../model/tosspayments_result.dart';

class PaymentCallback {
  final void Function(Success) onPaymentSuccess;
  final void Function(Fail) onPaymentFailed;

  const PaymentCallback({
    required this.onPaymentSuccess,
    required this.onPaymentFailed,
  });
}
