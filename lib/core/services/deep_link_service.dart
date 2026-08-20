import "dart:async";
import "package:app_links/app_links.dart";
import "package:draya_mobile/core/router/app_router.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:flutter/foundation.dart";

class DeepLinkService {
  final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  DeepLinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  void init() {
    // Listen to incoming deep links while app is running
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint("DeepLinkService error: $err");
      },
    );

    // Handle initial link if app was launched via deep link
    _handleInitialUri();
  }

  Future<void> _handleInitialUri() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint("DeepLinkService initial uri error: $e");
    }
  }

  void _handleDeepLink(Uri uri) {
    debugPrint("Received Deep Link: $uri");

    // Expected scheme: draya://payment-result?transactionId=...&status=...
    if (uri.scheme == "draya" && uri.host == "payment-result") {
      final transactionId = uri.queryParameters["transactionId"];
      if (transactionId != null && transactionId.isNotEmpty) {
        AppRouter.router.push(
          AppRoutes.paymentResultPage,
          extra: transactionId,
        );
      }
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
