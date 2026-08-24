import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/localization/locale_cubit.dart";
import "package:draya_mobile/core/router/app_router.dart";
import "package:draya_mobile/core/theme/app_theme.dart";
import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_cubit.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_state.dart";
import "package:draya_mobile/l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class DrayaApp extends StatelessWidget {
  const DrayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "Draya",
          theme: AppTheme.light,
          routerConfig: AppRouter.router,
          locale: const Locale("ar"),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) {
            return BlocProvider.value(
              value: getIt<NotificationsCubit>(),
              child: BlocListener<NotificationsCubit, NotificationsState>(
                // Only toast for real-time additions, never during the
                // initial REST hydration of older notifications.
                listenWhen: (previous, current) =>
                    current.notifications.isNotEmpty &&
                    previous.notifications.isNotEmpty &&
                    current.notifications.length >
                        previous.notifications.length,
                listener: (context, state) {
                  final notification = state.notifications.first;
                  _showNotificationToast(context, notification);
                },
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationToast(
    BuildContext context,
    AppNotification notification,
  ) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final colorScheme = Theme.of(context).colorScheme;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  switch (notification.type) {
                    AppNotificationType.info =>
                      Icons.notifications_none_rounded,
                    AppNotificationType.success =>
                      Icons.check_circle_outline,
                    AppNotificationType.warning =>
                      Icons.warning_amber_rounded,
                    AppNotificationType.error => Icons.error_outline_rounded,
                  },
                  size: 20,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
