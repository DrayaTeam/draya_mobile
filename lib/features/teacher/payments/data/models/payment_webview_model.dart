class PaymentWebviewModel {
  final String appBarTitle;
  final String url;
  final String? transactionId;

  const PaymentWebviewModel({
    required this.appBarTitle,
    required this.url,
    this.transactionId,
  });
}
