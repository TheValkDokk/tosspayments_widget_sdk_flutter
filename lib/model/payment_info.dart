import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';

class PaymentInfo {
  final String orderId;
  final String orderName;
  final String? customerEmail;
  final String? customerName;
  final String? appScheme;
  final num? taxFreeAmount;
  final String? taxExemptionAmount;
  final bool? cultureExpense;
  final bool? useEscrow;
  final List<EscrowProduct>? escrowProducts;
  final String? customerMobilePhone;
  final bool? showCustomerMobilePhone;
  final List<String>? mobileCarrier;
  final List<Product>? products;
  final Shipping? shipping;
  final PaymentMethodOptions? paymentMethodOptions;
  final bool? useInternationalCardOnly;
  final Map<String, String>? metadata;

  const PaymentInfo({
    required this.orderId,
    required this.orderName,
    this.customerEmail,
    this.customerName,
    this.appScheme,
    this.taxFreeAmount,
    this.taxExemptionAmount,
    this.cultureExpense,
    this.useEscrow,
    this.escrowProducts,
    this.customerMobilePhone,
    this.showCustomerMobilePhone = true,
    this.mobileCarrier,
    this.products,
    this.shipping,
    this.paymentMethodOptions,
    this.useInternationalCardOnly,
    this.metadata,
  });

  Map<String, dynamic> toJson() => _$PaymentInfoToJson(this);
}

Map<String, dynamic> _$PaymentInfoToJson(PaymentInfo paymentInfo) {
  final val = <String, dynamic>{};

  void ifNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  val['orderId'] = paymentInfo.orderId;
  val['orderName'] = paymentInfo.orderName;
  ifNotNull('customerEmail', paymentInfo.customerEmail);
  ifNotNull('customerName', paymentInfo.customerName);
  ifNotNull('appScheme', paymentInfo.appScheme);
  ifNotNull('taxFreeAmount', paymentInfo.taxFreeAmount);
  ifNotNull('taxExemptionAmount', paymentInfo.taxExemptionAmount);
  ifNotNull('cultureExpense', paymentInfo.cultureExpense);
  ifNotNull('useEscrow', paymentInfo.useEscrow);
  ifNotNull('escrowProducts', paymentInfo.escrowProducts);
  ifNotNull('customerMobilePhone', paymentInfo.customerMobilePhone);
  ifNotNull('showCustomerMobilePhone', paymentInfo.showCustomerMobilePhone);
  ifNotNull('mobileCarrier', paymentInfo.mobileCarrier);
  ifNotNull('products', paymentInfo.products);
  ifNotNull('shipping', paymentInfo.shipping);
  ifNotNull('paymentMethodOptions', paymentInfo.paymentMethodOptions);
  ifNotNull('useInternationalCardOnly', paymentInfo.useInternationalCardOnly);
  ifNotNull('metadata', paymentInfo.metadata);
  return val;
}

class EscrowProduct {
  final String id;
  final String name;
  final String code;
  final num unitPrice;
  final num quantity;

  const EscrowProduct(
      {required this.id, required this.name, required this.code, required this.unitPrice, required this.quantity});

  Map toJson() => {'id': id, 'name': name, 'code': code, 'unitPrice': unitPrice, 'quantity': quantity};
}

class Product {
  final String name;
  final num quantity;
  final num unitamount;
  final String currency;
  final String description;

  const Product(
      {required this.name,
      required this.quantity,
      required this.unitamount,
      required this.currency,
      required this.description});

  Map toJson() =>
      {'name': name, 'quantity': quantity, 'unitamount': unitamount, 'currency': currency, 'description': description};
}

class Shipping {
  final String fullName;
  final Address address;

  const Shipping({required this.fullName, required this.address});

  Map toJson() => {'fullName': fullName, 'address': address};
}

class Address {
  final String country;
  final String? line1;
  final String? line2;
  final String? area1;
  final String area2;
  final String? postalCode;

  const Address({required this.country, this.line1, this.line2, this.area1, required this.area2, this.postalCode});

  Map toJson() {
    final val = <String, dynamic>{};

    val['country'] = country;
    if (line1 != null) val['line1'] = line1;
    if (line2 != null) val['line2'] = line2;
    if (area1 != null) val['area1'] = area1;
    val['area2'] = area2;
    if (postalCode != null) val['postalCode'] = postalCode;
    return val;
  }
}
