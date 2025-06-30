// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentTypeMethodInfo {
  final String type;
  final String method;
  final PaymentProviderInfo? easyPay;

  PaymentTypeMethodInfo({
    required this.type,
    required this.method,
    required this.easyPay,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'method': method,
      'easyPay': easyPay?.toMap(),
    };
  }

  factory PaymentTypeMethodInfo.fromMap(Map<String, dynamic> map) {
    return PaymentTypeMethodInfo(
      type: map['type'] as String,
      method: map['method'] as String,
      easyPay: map['easyPay'] != null
          ? PaymentProviderInfo.fromMap(map['easyPay'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentTypeMethodInfo.fromJson(String source) =>
      PaymentTypeMethodInfo.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'PaymentTypeMethodInfo(type: $type, method: $method, easyPay: $easyPay)';
}

class PaymentProviderInfo {
  final String provider;

  PaymentProviderInfo({required this.provider});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'provider': provider};
  }

  factory PaymentProviderInfo.fromMap(Map<String, dynamic> map) {
    return PaymentProviderInfo(provider: map['provider'] as String);
  }

  String toJson() => json.encode(toMap());

  factory PaymentProviderInfo.fromJson(String source) =>
      PaymentProviderInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PaymentProviderInfo(provider: $provider)';
}
