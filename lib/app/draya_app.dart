import 'package:draya_mobile/features/home/presentation/home_screen/pages/home_screen_page.dart';
import 'package:flutter/material.dart';

class DrayaApp extends StatelessWidget {
  const DrayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Draya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreenPage(),
    );
  }
}
