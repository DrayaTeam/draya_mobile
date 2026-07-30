import 'package:draya_mobile/core/localization/locale_cubit.dart';
import 'package:draya_mobile/core/router/app_router.dart';
import 'package:draya_mobile/core/theme/app_theme.dart';
import 'package:draya_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrayaApp extends StatelessWidget {
  const DrayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Draya',
          theme: AppTheme.light,
          routerConfig: AppRouter.router,
          locale: state,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
