import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_cubit.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_state.dart";
import "package:draya_mobile/features/notifications/presentation/widgets/unread_badge.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({super.key, required this.title, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        BlocProvider.value(
          value: getIt<NotificationsCubit>(),
          child: Semantics(
            label: "الإشعارات",
            button: true,
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () =>
                          context.push(AppRoutes.notificationsPage),
                    ),
                    if (state.unreadCount > 0)
                      PositionedDirectional(
                        top: AppSizes.s6,
                        end: AppSizes.s6,
                        child: UnreadBadge(count: state.unreadCount),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: AppSizes.s16),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
