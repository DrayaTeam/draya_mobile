import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_cubit.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_state.dart";
import "package:draya_mobile/features/notifications/presentation/widgets/notification_card.dart";
import "package:draya_mobile/features/notifications/presentation/widgets/notifications_empty_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NotificationsCubit>()..ensureConnected(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "الإشعارات"),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                state.notifications.isEmpty
                ? const NotificationsEmptyState(
                    key: ValueKey("empty"),
                  )
                : _NotificationsList(
                    key: const ValueKey("list"),
                    state: state,
                  ),
          );
        },
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final NotificationsState state;

  const _NotificationsList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s8,
          ),
          child: Row(
            children: [
              Text(
                "${state.unreadCount} غير مقروء",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              if (state.unreadCount > 0)
                TextButton(
                  onPressed: cubit.markAllAsRead,
                  child: const Text("تحديد الكل كمقروء"),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s16,
              AppSizes.s4,
              AppSizes.s16,
              AppSizes.s24,
            ),
            itemCount: state.notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.s10),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];

              return FadeInUp(
                delay: index * 60,
                child: NotificationCard(
                  notification: notification,
                  onTap: () => cubit.markAsRead(notification.id),
                  onDismiss: () => cubit.removeNotification(notification.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
