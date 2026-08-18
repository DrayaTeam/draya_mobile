import 'dart:async';
import 'dart:developer';

import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
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
  bool _hasHandledRedirect = false;
  int _loadingProgress = 0;

  void _handlePaymentRedirect(String url) {
    if (_hasHandledRedirect || !mounted) return;
    _hasHandledRedirect = true;

    final uri = Uri.tryParse(url);
    String? transactionId =
        uri?.queryParameters['transactionId'] ??
        uri?.queryParameters['merchant_order_id'] ??
        uri?.queryParameters['id'] ??
        uri?.queryParameters['paymentTransactionId'] ??
        uri?.queryParameters['order'] ??
        widget._paymentWebviewModel.transactionId;

    log(url);

    if (transactionId == null || transactionId.isEmpty) {
      transactionId = widget._paymentWebviewModel.transactionId ?? '';
    }

    AppNavigator.pushReplacement(
      context: context,
      path: AppRoutes.paymentResultPage,
      extra: transactionId,
    );
  }

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
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onNavigationRequest: (request) {
            final url = request.url;

            // 1. Intercept ANY custom draya:// redirect
            if (url.startsWith('draya://') || url.startsWith('draya:')) {
              _handlePaymentRedirect(url);
              return NavigationDecision.prevent;
            }

            // 2. Prevent arbitrary non-web schemes from crashing the webview
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              return NavigationDecision.prevent;
            }

            // 3. Legacy teacher wallet confirmation (if applicable)
            final isLocalRedirect = RegExp(
              r"^http:\/\/localhost:",
            ).hasMatch(url);
            final isSuccessRedirect = url.toLowerCase().contains('success');
            final isCancelRedirect = url.toLowerCase().contains('cancel');

            if (widget._paymentWebviewModel.transactionId != null &&
                (isSuccessRedirect || isLocalRedirect)) {
              unawaited(_confirmPaymentSuccess());
              return NavigationDecision.prevent;
            }

            if (isCancelRedirect) {
              AppNavigator.pop(context: context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            final failingUrl = error.url;
            if (failingUrl != null &&
                (failingUrl.startsWith('draya://') ||
                    failingUrl.startsWith('draya:'))) {
              _handlePaymentRedirect(failingUrl);
            }
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
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (_loadingProgress < 100)
              LinearProgressIndicator(
                value: _loadingProgress / 100.0,
                backgroundColor: Colors.transparent,
                color: AppColors.primary700,
                minHeight: 3,
              ),
          ],
        ),
      ),
    );
  }
}
