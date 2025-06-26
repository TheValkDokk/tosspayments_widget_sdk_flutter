import 'dart:convert';

import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/widget_container.dart';

import '../model/agreement_status.dart';
import '../model/payment_widget_options.dart';
import '../webview/javascript_channel.dart';

class AgreementWidget extends WidgetContainer {
  final void Function(AgreementStatus)? onChange;

  AgreementWidget({required PaymentWidget paymentWidget, required String selector, this.onChange})
      : super(key: paymentWidget.getGlobalKey<PaymentAgreementWidgetState>(selector), paymentWidget: paymentWidget);

  @override
  WidgetContainerState createState() => PaymentAgreementWidgetState();
}

class PaymentAgreementWidgetState extends WidgetContainerState {
  Future<AgreementWidgetControl> renderAgreement({RenderAgreementOptions? options}) async {
    addJavascriptChannels(agreementWidgetJavascriptChannels);

    final optionsJson = jsonEncode(options?.toJson() ?? '');

    String renderScript = 'const agreementWidget = paymentWidget.renderAgreement(\'#agreement\', $optionsJson);';
    try {
      await renderWidget(renderScript: renderScript);
      return AgreementWidgetControl._(getAgreementStatus: _getAgreementStatus);
    } catch (fail) {
      return Future.error(fail);
    }
  }

  Future<AgreementStatus> _getAgreementStatus() async {
    return AgreementStatus.fromJson(await evaluateJavascriptWithResolve('agreementWidget.getAgreementStatus()'));
  }

  Set<JavascriptChannel> get agreementWidgetJavascriptChannels => {
        JavascriptChannel(
            name: "updateAgreementStatus",
            onReceived: (jsonObject) {
              var agreementStatus = AgreementStatus.fromJson(jsonObject);
              (widget as AgreementWidget).onChange?.call(agreementStatus);
            }),
      };
}

/// [renderAgreement]로 얻을 수 있는 클래스입니다.
/// [getAgreementStatus] : 고객의 필수 약관 동의 상태를 반환합니다.
class AgreementWidgetControl {
  final Future<AgreementStatus> Function() getAgreementStatus;

  const AgreementWidgetControl._({
    required this.getAgreementStatus,
  });
}
