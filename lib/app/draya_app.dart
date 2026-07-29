import 'package:draya_mobile/core/router/app_router.dart';
import 'package:draya_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DrayaApp extends StatelessWidget {
  const DrayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Draya',
      theme: AppTheme.light,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
