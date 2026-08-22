import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";

class NotificationsState {
  final List<AppNotification> notifications;
  final bool isConnected;

  const NotificationsState({
    this.notifications = const [],
    this.isConnected = false,
  });

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    bool? isConnected,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
