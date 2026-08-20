import "package:draya_mobile/core/router/app_router.dart";
import "package:draya_mobile/core/widgets/app_custom_loading.dart";
import "package:flutter/material.dart";

abstract final class AppLoading {
  static bool _isVisible = false;

  static void show({String? text}) {
    if (_isVisible) {
      return;
    }

    final context = AppRouter.navigatorKey.currentContext;

    if (context == null) {
      return;
    }

    _isVisible = true;

    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return AppCustomLoading(
          text: text,
        );
      },
    ).whenComplete(
      () {
        _isVisible = false;
      },
    );
  }

  static void hide() {
    if (!_isVisible) {
      return;
    }

    final navigator = AppRouter.navigatorKey.currentState;

    if (navigator == null) {
      _isVisible = false;
      return;
    }

    if (navigator.canPop()) {
      navigator.pop();
    }
    _isVisible = false;
  }
}
