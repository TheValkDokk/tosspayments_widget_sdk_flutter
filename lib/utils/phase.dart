class PhaseConfig {
  static Phase phase = Phase.live;

  static String get paymentWidgetHtml => '''
    <html lang="ko">
    
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>
        <script type='text/javascript'>
          window.PaymentWidgetFlutterSDK = {
            message : {
              postMessage : function(_message) {
                window.flutter_inappwebview.callHandler('PaymentWidgetFlutterSDK', _message);
              }
            },
            error : {
              postMessage : function(error) {
                window.flutter_inappwebview.callHandler('PaymentWidgetFlutterSDK', JSON.stringify({
                  name: 'error', 
                  params: JSON.parse(error)
                }));
              }
            }
          }
        </script>
        <script src="https://js.tosspayments.com/${phase.toString()}/payment-widget"></script>
    </head>
    
    <body style="margin:0;padding:0">
    <div id="payment-method"></div>
    <div id="agreement"></div>
    </body>
    </html>
  ''';
}

enum Phase {
  dev,
  staging,
  live;

  @override
  String toString() {
    if (this == Phase.dev) {
      return 'alpha';
    } else if (this == Phase.staging) {
      return 'beta';
    } else {
      return 'v1';
    }
  }
}
