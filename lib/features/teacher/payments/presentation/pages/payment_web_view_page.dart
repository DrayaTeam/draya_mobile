import 'dart:async';

import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/confirm_payment_cubit.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final PaymentWebviewModel _paymentWebviewModel;
  const PaymentWebViewPage(this._paymentWebviewModel, {super.key});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _webViewController;
  bool _isProcessingConfirmation = false;

  Future<void> _confirmPaymentSuccess() async {
    if (_isProcessingConfirmation) return;

    final paymentId = widget._paymentWebviewModel.transactionId;

    if (paymentId == null || paymentId.isEmpty) {
      AppNavigator.pop(context: context);
      return;
    }

    setState(() {
      _isProcessingConfirmation = true;
    });

    try {
      await context.read<ConfirmPaymentCubit>().confirmPayment(
        paymentId: paymentId,
        isSuccess: true,
      );

      if (!mounted) return;

      await context.read<WalletCubit>().getTeacherBalance();
      if (mounted) {
        AppNavigator.pop(context: context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingConfirmation = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            final isLocalRedirect = RegExp(
              r"^http:\/\/localhost:",
            ).hasMatch(url);
            final isSuccessRedirect = url.toLowerCase().contains('success');
            final isCancelRedirect = url.toLowerCase().contains('cancel');

            if (isSuccessRedirect || isLocalRedirect) {
              unawaited(_confirmPaymentSuccess());
              return NavigationDecision.prevent;
            }

            if (isCancelRedirect) {
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
