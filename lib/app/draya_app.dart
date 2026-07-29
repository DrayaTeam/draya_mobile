import 'package:draya_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';

class DrayaApp extends StatelessWidget {
  const DrayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // debugShowCheckedModeBanner: false,
      title: 'Draya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
