import 'dart:core';

/// [TossPaymentResult] is an abstract class representing the result of a Toss payment operation.
abstract class TossPaymentResult {}

/// [Success] class extends [TossPaymentResult] and is used when a Toss payment operation is successful.
class Success extends TossPaymentResult {
  /// Constructs a [Success] object.
  ///
  /// [paymentKey] represents the key of the successful payment.
  /// [orderId] represents the id of the order related to the successful payment.
  /// [amount] represents the amount of the successful payment.
  Success(this.paymentKey, this.orderId, this.amount, this.additionalParams);

  final String paymentKey;
  final String orderId;
  final num amount;
  final Map<String, String>? additionalParams;

  @override
  String toString() {
    return 'paymentKey : $paymentKey\norderId : $orderId\namount : $amount\nadditionalParams: $additionalParams';
  }
}

/// [Fail] class extends [TossPaymentResult] and is used when a Toss payment operation fails.
class Fail extends TossPaymentResult {

  /// Constructs a [Fail] object.
  ///
  /// [errorCode] is the error code representing the reason for the payment failure.
  /// [errorMessage] is a message explaining the reason for the payment failure.
  /// [orderId] represents the id of the order related to the failed payment.
  Fail(this.errorCode, this.errorMessage, this.orderId);

  final String errorCode;
  final String errorMessage;
  final String orderId;
}

class Result {
  final Success? success;
  final Fail? fail;

  const Result({this.success, this.fail});
}
