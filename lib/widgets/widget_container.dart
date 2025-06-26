import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/utils/event_waiter.dart';
import 'package:tosspayments_widget_sdk_flutter/utils/phase.dart';
import 'package:tosspayments_widget_sdk_flutter/utils/version.dart';

import '../model/tosspayments_url.dart';
import '../webview/javascript_channel.dart';
import '../webview/payment_window_in_app_webview.dart';

abstract class WidgetContainer extends StatefulWidget {
  final PaymentWidget _paymentWidget;

  const WidgetContainer({Key? key, required PaymentWidget paymentWidget})
      : _paymentWidget = paymentWidget,
        super(key: key);

  @override
  WidgetContainerState createState() => WidgetContainerState();
}

class WidgetContainerState extends State<WidgetContainer> {
  final eventManager = EventManager();

  double? _height;
  String orderId = "";

  final GlobalKey<TosspaymentsInAppWebviewState> _webViewKey = GlobalKey();

  String? get redirectUrl => widget._paymentWidget.paymentWidgetOptions?.brandPayOption?.redirectUrl;

  String? get domain {
    try {
      if (redirectUrl?.isNotEmpty == true) {
        return Uri.parse(redirectUrl!).host;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    eventManager.addEvent('widgetStatus');
    eventManager.addEvent('resolve');
  }

  @override
  void dispose() {
    eventManager.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height ?? 1,
      child: TosspaymentsInAppWebview(
        key: _webViewKey,
        initialHtml: PhaseConfig.paymentWidgetHtml,
        handleOverrideUrl: _handleOverrideUrl,
        domain: domain,
      ),
    );
  }

  Future<dynamic> renderWidget({
    required String renderScript,
  }) async {
    final osVersion = await getOSVersion();
    addJavascriptChannels(widgetJavascriptChannels);
    return evaluateJavascriptFuture('''
      var paymentWidget = PaymentWidget(
        '${widget._paymentWidget.clientKey}', 
        '${widget._paymentWidget.customerKey}', 
        {'brandpay':{'redirectUrl':'${redirectUrl ?? ''}'}, 
        'service': 'payment-widget-flutter', 
        'environment': { 
          'platform' : '${Platform.isAndroid ? 'android' : 'ios'}', 
          'sdkVersion' : '$sdkPackageVersion', 
          'osVersion' : '$osVersion'
        } 
      });
      $renderScript
    ''', 'widgetStatus');
  }

  void updateHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  /// 웹뷰에 JavascriptChannel set [channels]를 추가
  void addJavascriptChannels(Set<JavascriptChannel> channels) {
    _webViewKey.currentState?.addJavascriptChannels(channels);
  }

  /// [script] 를 웹뷰에서 evaluate (evaluate 결과 응답이 필요 없을 경우 사용)
  void evaluateJavascript(String script) {
    _webViewKey.currentState?.evaluateJavascript('javascript:$script');
  }

  /// [script]를 evaluate한 후, [bridge] 이름의 JavascriptChannel로 받은 params를 Future로 반환
  Future<dynamic> evaluateJavascriptFuture(String script, String bridge) async {
    var future = eventManager.waitForEvent(bridge);
    evaluateJavascript(script);
    return future;
  }

  /// 고유한 세션 키로 [script]를 evaluate한 후, JavascriptChannel로 받은 해당 세션 키의 params를 Future로 반환
  Future<dynamic> evaluateJavascriptWithResolve(String script) async {
    final sessionKey = DateTime.now().millisecondsSinceEpoch;

    Future<dynamic> resolved = eventManager.waitForResolveWithKey(sessionKey);
    evaluateJavascript('''
      window.PaymentWidgetFlutterSDK.message.postMessage(JSON.stringify({
        name : 'resolve',
        params : {
          key : '$sessionKey',
          data : $script
        }
      }));
      true;
    ''');
    return await resolved;
  }

  // 모든 위젯이 공통으로 받는 JavascriptChannel
  Set<JavascriptChannel> get widgetJavascriptChannels => {
        JavascriptChannel(
            name: "updateHeight",
            onReceived: (jsonObject) {
              num height = jsonObject['height'];
              updateHeight(height.toDouble());
            }),
        JavascriptChannel(
            name: "widgetStatus",
            onReceived: (jsonObject) {
              var status = jsonObject['status'];
              if (status == 'load') {
                eventManager.triggerEvent('widgetStatus', null);
              }
            }),
        JavascriptChannel(
            name: "resolve",
            onReceived: (jsonObject) {
              eventManager.triggerEvent('resolve', jsonObject);
            }),
      };

  // Agreements와 Methods가 url을 handle하는 방법
  Future<bool> _handleOverrideUrl(String requestedUrl) async {
    final convertUrl = ConvertUrl(requestedUrl);

    if (Platform.isAndroid) {
      convertUrl.launchApp();
      return true;
    }

    final isHtml = requestedUrl.startsWith('data:text/html');
    final isNetworkUrl = convertUrl.appScheme == 'http' || convertUrl.appScheme == 'https';
    final isIntent = convertUrl.appScheme == 'intent';

    if (isHtml || isIntent) {
      return false;
    } else if (isNetworkUrl) {
      if (requestedUrl == 'https://$domain/') {
        return false;
      } else if (Uri.parse(requestedUrl).host.startsWith('payment-widget')) {
        // NOTE (@JooYang): 결제위젯 제품의 /popup-bridge 에서 열리는 무이자할부 페이지는 웹뷰 내부에서 이동하지 않고 외부 앱에서 엽니다.
        // @see {https://www.notion.so/tossteam/iOS-15aa360d33e38011ace8f6bea15c5ccf?pvs=4}
        if (Uri.parse(requestedUrl).path == '/popup-bridge') {
          await convertUrl.launchApp();
          return true;
        }

        return false;
      } else if (isIntent) {
        await convertUrl.launchApp();
      } else {
        await convertUrl.launchApp();
      }
    }

    return true;
  }
}
