// **************************************************************************
// 수정 불가! 파라미터별 상세 설명은 https://docs.tosspayments.com/reference
// **************************************************************************


import 'package:json_annotation/json_annotation.dart';
part 'paymentData.g.dart';

@JsonSerializable()
class PaymentData {
  @JsonKey(name: 'paymentMethod')
  String paymentMethod; /// 결제수단

  @JsonKey(name: 'amount')
  num amount ; /// 결제되는 금액입니다.

  @JsonKey(name: 'orderId')
  String orderId; /// 주문 ID입니다. 충분히 무작위한 값을 직접 생성해서 사용하세요. 영문 대소문자, 숫자, 특수문자 -, _, =로 이루어진 6자 이상 64자 이하의 문자열이어야 합니다.

  @JsonKey(name: 'orderName')
  String orderName; ///주문명입니다. 예를 들면 생수 외 1건 같은 형식입니다. 최대 길이는 100자입니다.

  @JsonKey(name: 'successUrl')
  String? successUrl; ///결제 성공시 redirect되는 URL

  @JsonKey(name: 'failUrl')
  String? failUrl; ///결제 실패시 redirect되는 URL

  @JsonKey(name: 'customerName')
  String? customerName ; /// 고객의 이름입니다. 최대 길이는 100자입니다.

  @JsonKey(name: 'customerEmail')
  String? customerEmail; /// 고객의 이름입니다. 최대 길이는 100자입니다.

  @JsonKey(name: 'taxFreeAmount')
  num? taxFreeAmount; ///결제 금액 중 면세 금액입니다. 값을 넣지 않으면 기본값인 0으로 설정됩니다.

  @JsonKey(name: 'taxExemptionAmount')
  int? taxExemptionAmount ; /// 결제 금액 중 과세 제외 금액(컵 보증금 등)입니다. 값을 넣지 않으면 기본값인 0으로 설정됩니다. 카드 결제 또는 간편결제로 계좌이체할 때 사용하세요.

  @JsonKey(name: 'flowMode')
  String? flowMode; /// DEFAULT는 카드, 간편결제 수단이 있는 기본 결제창을 호출합니다. 기본값입니다. DIRECT는 앱카드 또는 간편결제사 결제창을 호출합니다. 앱카드를 호출하려면 cardCompany를 설정하세요. 간편결제사 결제창을 호출하려면 easyPay를 설정하세요.

  @JsonKey(name: 'cardCompany')
  String? cardCompany; ///카드사 코드입니다. flowMode 값이 DEFAULT이면 설정한 카드사만 보이는 기본 결제창이 열립니다. flowMode 값이 DIRECT이면 설정한 카드사의 결제창이 열립니다.

  @JsonKey(name: 'easyPay')
  String? easyPay; ///간편결제사 코드입니다. flowMode 값이 DIRECT이면 설정한 간편결제사의 결제창이 열립니다.

  @JsonKey(name: 'useInternationalCardOnly')
  bool? useInternationalCardOnly; ///해외카드(Visa, MasterCard, UnionPay) 결제 여부입니다. 값이 true면 해외카드 결제가 가능한 영문 결제창이 열립니다.

  @JsonKey(name: 'cardInstallmentPlan')
  num? cardInstallmentPlan; /// 카드 결제의 할부 개월 수를 고정해 결제창을 열 때 사용합니다. 결제 금액(amount)이 5만원 이상일 때만 사용할 수 있습니다. 2부터 12사이의 값을 사용할 수 있고, 0이 들어가면 할부가 아닌 일시불로 결제됩니다. 값을 넣지 않으면 결제창에서 전체 할부 개월 수를 선택할 수 있습니다.

  @JsonKey(name: 'maxCardInstallmentPlan')
  num? maxCardInstallmentPlan; ///카드 결제에서 선택할 수 있는 최대 할부 개월 수를 제한합니다. 결제 금액(amount)이 5만원 이상일 때만 사용할 수 있습니다. 2부터 12사이의 값을 사용할 수 있고, 0이 들어가면 할부가 아닌 일시불로 결제됩니다. 만약 값을 6으로 설정한다면 결제창에서 일시불~6개월 사이로 할부 개월을 선택할 수 있습니다.

  @JsonKey(name: 'useCardPoint')
  bool? useCardPoint; ///카드로 결제할 때 설정하는 카드사 포인트 사용 여부입니다.

  @JsonKey(name: 'useAppCardOnly')
  bool? useAppCardOnly; /// 이 값을 true로 주면 카드사의 앱카드 결제창만 열립니다.


  @JsonKey(name: 'discountCode')
  String? discountCode; ///카드사의 할인 코드입니다. flowMode 값이 DIRECT여야 합니다.

  @JsonKey(name: 'appScheme')
  String? appScheme; ///모바일 ISP 앱에서 상점 앱으로 돌아올 때 사용됩니다. 상점의 앱 스킴을 지정하면 됩니다. 예를 들면 testapp://같은 형태입니다.

  /// 가상게좌
  @JsonKey(name: 'cultureExpense')
  bool? cultureExpense ; ///문화비(도서, 공연 티켓, 박물관·미술관 입장권 등) 지출 여부입니다.

  @JsonKey(name: 'validHours')
  num? validHours; /// 가상계좌가 유효한 시간을 의미합니다. 값을 넣지 않으면 기본값 168시간(7일)으로 설정됩니다. 설정할 수 있는 최대값은 720시간(30일)입니다.

  @JsonKey(name: 'dueDate')
  String? dueDate; ///입금 기한입니다. 현재 시간을 기준으로 720시간(30일) 이내의 특정 시점으로 입금 기한을 직접 설정하고 싶을 때 사용합니다. 720시간 이후로 기한을 설정하면 에러가 발생합니다.

  @JsonKey(name: 'customerMobilePhone')
  String? customerMobilePhone; ///고객의 휴대폰 번호입니다. 가상계좌 입금 안내가 전송되는 번호입니다.

  @JsonKey(name: 'showCustomerMobilePhone')
  bool? showCustomerMobilePhone; /// 결제창에서 휴대폰 번호 입력 필드를 보여줄 지 여부입니다.

  @JsonKey(name: 'cashReceipt')
  Map<String, String>? cashReceipt; ///현금영수증 발급 정보를 담는 객체입니다.

  @JsonKey(name: 'useEscrow')
  bool? useEscrow; ///에스크로 사용 여부입니다.

  @JsonKey(name: 'escrowProducts')
  List<Map<String, Object>>? escrowProducts; ///각 상품의 상세 정보를 담는 배열입니다.

  @JsonKey(name: 'refundReceiveAccount')
  Map<String, String>? refundReceiveAccount; ///가상계좌로 결제했을 때 고객에게 환불해 줄 계좌 정보입니다.

  @JsonKey(name: 'mobileCarrier')
  List<String>? mobileCarrier; ///결제창에서 선택할 수 있는 통신사를 제한합니다. 배열에 통신사 코드를 추가하면 해당 통신사 코드만 선택할 수 있는 결제창이 뜹니다.

  PaymentData({
    required this.paymentMethod,
    required this.amount,
    required this.orderId,
    required this.orderName,
    this.successUrl,
    this.failUrl,
    this.customerName,
    this.customerEmail,
    this.taxFreeAmount,
    this.taxExemptionAmount,
    this.flowMode,
    this.cardCompany,
    this.easyPay,
    this.useInternationalCardOnly,
    this.cardInstallmentPlan,
    this.maxCardInstallmentPlan,
    this.useCardPoint,
    this.useAppCardOnly,
    this.discountCode,
    this.appScheme,
    this.cultureExpense,
    this.validHours,
    this.dueDate,
    this.customerMobilePhone,
    this.showCustomerMobilePhone,
    this.cashReceipt,
    this.useEscrow,
    this.escrowProducts,
    this.refundReceiveAccount,
    this.mobileCarrier
  });

  /// JSON 형식의 데이터를 [PaymentData] 형식으로 변환합니다.
  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);

  /// [PaymentData] 형식의 데이터를 JSON 형식으로 변환합니다.
  Map<String, dynamic> toJson() => _$PaymentDataToJson(this);
}