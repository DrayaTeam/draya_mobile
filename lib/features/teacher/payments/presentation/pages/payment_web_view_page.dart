import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final PaymentWebviewModel _paymentWebviewModel;
  const PaymentWebViewPage(this._paymentWebviewModel, {super.key});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (RegExp(r"^http:\/\/localhost:").hasMatch(request.url)) {
              AppNavigator.pop(context: context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget._paymentWebviewModel.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._paymentWebviewModel.appBarTitle),
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
