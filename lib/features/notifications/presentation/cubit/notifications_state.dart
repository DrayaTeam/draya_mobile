import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";

class NotificationsState {
  final List<AppNotification> notifications;
  final bool isConnected;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;

  /// Authoritative unread count coming from the backend
  /// (GET /notifications response + real-time deltas).
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.isConnected = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.currentPage = 1,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    bool? isConnected,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isConnected: isConnected ?? this.isConnected,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
