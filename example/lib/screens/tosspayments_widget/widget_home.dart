import 'dart:io';

import 'package:example/component/map_input_widget.dart';
import 'package:example/screens/tosspayments_widget/payment_widget_example_page.dart';
import 'package:example/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';

class WidgetHome extends StatefulWidget {
  const WidgetHome({super.key});

  @override
  WidgetHomeState createState() => WidgetHomeState();
}

class WidgetHomeState extends State<WidgetHome> {
  final _form = GlobalKey<FormState>();
  late String orderId; // 주문번호
  late String orderName; // 주문명
  final GlobalKey<MapDataInputWidgetState> _metadataInputWidgetKey = GlobalKey<MapDataInputWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('toss payments 결제 테스트'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Client Key',
                ),
                initialValue: LocalConfig.uiState.clientKey,
                onSaved: (String? value) {
                  LocalConfig.uiState.clientKey = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Customer Key',
                ),
                initialValue: LocalConfig.uiState.customerKey,
                onSaved: (String? value) {
                  LocalConfig.uiState.customerKey = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '주문번호(orderId)',
                ),
                initialValue: 'tosspaymentsFlutter_${DateTime.now().millisecondsSinceEpoch}',
                onSaved: (String? value) {
                  orderId = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '주문명(orderName)',
                ),
                initialValue: 'Toss T-shirt',
                onSaved: (String? value) {
                  orderName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '결제금액(amount)',
                ),
                initialValue: '50000',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (String? value) {
                  LocalConfig.uiState.amount = int.parse(value!);
                },
              ),
              DropdownButtonFormField<Currency>(
                value: Currency.KRW,
                decoration: const InputDecoration(
                  labelText: '통화',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                ),
                onChanged: (Currency? newValue) {
                  LocalConfig.uiState.currency = newValue ?? Currency.KRW;
                },
                items: Currency.values.map<DropdownMenuItem<Currency>>((Currency c) {
                  return DropdownMenuItem<Currency>(value: c, child: Text(c.name));
                }).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '국가 코드',
                ),
                initialValue: LocalConfig.uiState.country,
                keyboardType: TextInputType.text,
                onSaved: (String? value) {
                  LocalConfig.uiState.country = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Variant Key (Method)',
                ),
                initialValue: (() {
                  try {
                    return LocalConfig.uiState.variantKeyMethod;
                  } catch (e) {
                    return null;
                  }
                })(),
                keyboardType: TextInputType.text,
                onSaved: (String? value) {
                  LocalConfig.uiState.variantKeyMethod = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Variant Key (Agreement)',
                ),
                initialValue: (() {
                  try {
                    return LocalConfig.uiState.variantKeyAgreement;
                  } catch (e) {
                    return null;
                  }
                })(),
                keyboardType: TextInputType.text,
                onSaved: (String? value) {
                  LocalConfig.uiState.variantKeyAgreement = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Redirect Url',
                ),
                initialValue: (() {
                  try {
                    return LocalConfig.uiState.redirectUrl;
                  } catch (e) {
                    return null;
                  }
                })(),
                keyboardType: TextInputType.text,
                onSaved: (String? value) {
                  LocalConfig.uiState.redirectUrl = value;
                },
              ),
              DropdownButtonFormField<bool>(
                value: false,
                decoration: const InputDecoration(
                  labelText: 'useInternationalCardOnly',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                ),
                onChanged: (bool? newValue) {
                  LocalConfig.uiState.useInternationalCardOnly = newValue ?? false;
                },
                items: const [DropdownMenuItem(value: false, child: Text("false")), DropdownMenuItem(value: true, child: Text("true"))],
              ),
              const SizedBox(height: 20),
              MapDataInputWidget(label: 'metadata', key: _metadataInputWidgetKey),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      _form.currentState!.save();
                      final metadata = _metadataInputWidgetKey.currentState!.getMapData();

                      PaymentInfo data = PaymentInfo(
                        orderId: orderId,
                        orderName: orderName,
                        appScheme: Platform.isIOS ? 'example://' : null,
                        useInternationalCardOnly: LocalConfig.uiState.useInternationalCardOnly,
                        metadata: metadata.isEmpty ? null : metadata,
                      );
                      var result = await Get.to(
                        () => PaymentWidgetExamplePage(
                          data: data,
                          info: LocalConfig.uiState,
                        ),
                        popGesture: Platform.isIOS,
                        fullscreenDialog: Platform.isAndroid,
                      );
                      if (result != null) {
                        Get.toNamed("/result", arguments: result);
                      }
                    },
                    child: const Text(
                      '결제하기',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UIState {
  String clientKey;
  String customerKey;
  Currency currency;
  String country;
  num amount;
  String? variantKeyMethod;
  String? variantKeyAgreement;
  String? redirectUrl;
  bool? useInternationalCardOnly;

  UIState(
      {required this.clientKey,
      required this.customerKey,
      required this.currency,
      required this.country,
      required this.amount,
      this.variantKeyMethod,
      this.variantKeyAgreement,
      this.redirectUrl,
      this.useInternationalCardOnly});
}
