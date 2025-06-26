// **************************************************************************
// 수정 불가! 파라미터별 상세 설명은 https://docs.tosspayments.com/reference
// **************************************************************************
part of 'paymentData.dart';

/// A constant class that holds the success and fail URL strings.
class Constants {
  static const success = 'tosspayments://payment/flutter/success';
  static const fail = 'tosspayments://payment/flutter/fail';
}

/// Generates a `PaymentData` object from a [Map<String, dynamic>] instance.
/// The [Map<String, dynamic>] instance represents a JSON object.
PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) => PaymentData(
    paymentMethod: json['paymentMethod'] as String,
    amount: json['amount'] as num,
    orderId: json['orderId'] as String,
    orderName: json['orderName'] as String,
    successUrl: json['successUrl'] as String,
    failUrl: json['failUrl'] as String,
    customerName: json['customerName'] as String,
    customerEmail: json['customerEmail'] as String,
    taxFreeAmount: json['taxFreeAmount'] as num,
    taxExemptionAmount: json['taxExemptionAmount'] as int,
    flowMode: json['flowMode'] as String,
    cardCompany: json['cardCompany'] as String,
    easyPay: json['easyPay'] as String,
    useInternationalCardOnly: json['useInternationalCardOnly'] as bool,
    cardInstallmentPlan: json['cardInstallmentPlan'] as num,
    maxCardInstallmentPlan: json['maxCardInstallmentPlan'] as num,
    useCardPoint: json['useCardPoint'] as bool,
    useAppCardOnly: json['useAppCardOnly'] as bool,
    discountCode: json['discountCode'] as String,
    appScheme: json['appScheme'] as String,
    cultureExpense: json['cultureExpense'] as bool,
    validHours: json['validHours'] as num,
    dueDate: json['dueDate'] as String,
    customerMobilePhone: json['customerMobilePhone'] as String,
    showCustomerMobilePhone: json['showCustomerMobilePhone'] as bool,
    cashReceipt: (json['cashReceipt'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    useEscrow: json['useEscrow'] as bool,
    refundReceiveAccount:
        (json['refundReceiveAccount'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ));

/// Transforms a `PaymentData` object into a [Map<String, dynamic>] instance.
/// The resulting [Map<String, dynamic>] instance can be converted into a JSON object.
Map<String, dynamic> _$PaymentDataToJson(PaymentData instance) {
  final val = <String, dynamic>{};

  void ifNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  val['paymentMethod'] = instance.paymentMethod;
  val['amount'] = instance.amount;
  val['orderId'] = instance.orderId;
  val['orderName'] = instance.orderName;
  val['successUrl'] = Constants.success;
  val['failUrl'] = Constants.fail;
  ifNotNull('customerName', instance.customerName);
  ifNotNull('customerEmail', instance.customerEmail);
  ifNotNull('taxFreeAmount', instance.taxFreeAmount);
  ifNotNull('taxExemptionAmount', instance.taxExemptionAmount);
  ifNotNull('flowMode', instance.flowMode);
  ifNotNull('cardCompany', instance.cardCompany);
  ifNotNull('easyPay', instance.easyPay);
  ifNotNull('useInternationalCardOnly', instance.useInternationalCardOnly);
  ifNotNull('cardInstallmentPlan', instance.cardInstallmentPlan);
  ifNotNull('maxCardInstallmentPlan', instance.maxCardInstallmentPlan);
  ifNotNull('useCardPoint', instance.useCardPoint);
  ifNotNull('useAppCardOnly', instance.useAppCardOnly);
  ifNotNull('discountCode', instance.discountCode);
  ifNotNull('appScheme', instance.appScheme);
  ifNotNull('cultureExpense', instance.cultureExpense);
  ifNotNull('validHours', instance.validHours);
  ifNotNull('dueDate', instance.dueDate);
  ifNotNull('customerMobilePhone', instance.customerMobilePhone);
  ifNotNull('showCustomerMobilePhone', instance.showCustomerMobilePhone);
  ifNotNull('cashReceipt', instance.cashReceipt);
  ifNotNull('useEscrow', instance.useEscrow);
  ifNotNull('escrowProducts', instance.escrowProducts);
  ifNotNull('refundReceiveAccount', instance.refundReceiveAccount);
  ifNotNull('mobileCarrier', instance.mobileCarrier);
  return val;
}
