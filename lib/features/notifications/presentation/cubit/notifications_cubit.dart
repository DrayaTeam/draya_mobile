import "dart:async";
import "dart:math";

import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/core/services/local_notification_service.dart";
import "package:draya_mobile/core/signalr/signalr_events.dart";
import "package:draya_mobile/core/signalr/signalr_service.dart";
import "package:draya_mobile/features/notifications/data/source/notifications_api_service.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// Manages the unified notification system:
/// - REST hydration via [NotificationsApiService] (GET /notifications)
/// - Real-time events from the unified hub (/hubs/notifications):
///   ReceiveNotification + AnswerScoreOverridden
/// - Optimistic read/delete sync with the backend.
class NotificationsCubit extends Cubit<NotificationsState> {
  final SignalRService _signalRService;
  final LocalNotificationService _localNotifications;
  final NotificationsApiService _apiService;

  static const String _notificationsHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/notifications";
  static const String _notificationsHubKey = "notifications";

  static const int _pageSize = 20;

  /// Broadcast stream for AnswerScoreOverridden so open exam-attempt
  /// screens can update the overridden answer score in real time.
  final StreamController<AnswerScoreOverriddenEvent>
  _answerScoreOverriddenController =
      StreamController<AnswerScoreOverriddenEvent>.broadcast();

  Stream<AnswerScoreOverriddenEvent> get onAnswerScoreOverridden =>
      _answerScoreOverriddenController.stream;

  bool _initialized = false;

  NotificationsCubit(
    this._signalRService,
    this._localNotifications,
    this._apiService,
  ) : super(const NotificationsState()) {
    _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    // Unified notifications hub (real-time bell dropdown feed).
    _signalRService.onReceiveNotification(_handleNotificationReceived);

    // Teacher score-override push (also arrives on the same hub).
    _signalRService.onAnswerScoreOverridden(_handleAnswerScoreOverridden);

    await ensureConnected();
    await refresh();
  }

  /// Connects to the unified notifications hub as a background connection so
  /// it never clashes with the primary SignalR connection used by the
  /// classroom Q&A features. Safe to call multiple times.
  Future<void> ensureConnected() async {
    try {
      final token = await AppTokenHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      await _signalRService.connectBackgroundHub(
        key: _notificationsHubKey,
        hubUrl: _notificationsHubUrl,
        token: token,
      );

      emit(state.copyWith(isConnected: true));
    } catch (_) {
      emit(state.copyWith(isConnected: false));
    }
  }

  /// Re-fetches page 1 from REST and hydrates the store,
  /// including the authoritative unreadCount.
  Future<void> refresh() async {
    emit(state.copyWith(isInitialLoading: true));
    try {
      final page = await _apiService.getNotifications(
        page: 1,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          isInitialLoading: false,
          notifications: page.items,
          unreadCount: page.unreadCount,
          currentPage: 1,
          hasMore: page.items.length < page.totalCount,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isInitialLoading: false));
    }
  }

  /// Loads the next page of older notifications (infinite scroll).
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.currentPage + 1;
      final page = await _apiService.getNotifications(
        page: nextPage,
        pageSize: _pageSize,
      );
      final existingIds = state.notifications.map((n) => n.id).toSet();
      final newItems = page.items
          .where((n) => !existingIds.contains(n.id))
          .toList();
      emit(
        state.copyWith(
          isLoadingMore: false,
          notifications: [...state.notifications, ...newItems],
          unreadCount: page.unreadCount,
          currentPage: nextPage,
          hasMore:
              state.notifications.length + newItems.length < page.totalCount,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void _handleNotificationReceived(NotificationReceivedEvent event) {
    final notification = event.notification;
    if (state.notifications.any((n) => n.id == notification.id)) return;

    unawaited(
      _localNotifications.show(
        title: notification.title,
        body: notification.message,
      ),
    );

    emit(
      state.copyWith(
        notifications: [notification, ...state.notifications],
        unreadCount: notification.isRead
            ? state.unreadCount
            : state.unreadCount + 1,
      ),
    );
  }

  void _handleAnswerScoreOverridden(AnswerScoreOverriddenEvent event) {
    _answerScoreOverriddenController.add(event);

    unawaited(
      _localNotifications.show(
        title: "تم تحديث درجة إجابتك",
        body: "قام معلمك بتحديث درجة إحدى إجاباتك إلى ${_formatScore(event.newScore)}.",
      ),
    );
  }

  String _formatScore(double score) =>
      score % 1 == 0 ? score.toStringAsFixed(0) : score.toStringAsFixed(1);

  /// Optimistically marks a notification as read, then syncs with the API.
  void markAsRead(String id) {
    bool wasUnread = false;
    final updated = state.notifications.map((notification) {
      if (notification.id == id && !notification.isRead) {
        wasUnread = true;
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    emit(
      state.copyWith(
        notifications: updated,
        unreadCount: wasUnread ? max(0, state.unreadCount - 1) : state.unreadCount,
      ),
    );

    if (wasUnread) {
      unawaited(_apiService.markAsRead(id).catchError((_) {}));
    }
  }

  /// Optimistically marks all as read, then syncs with the API.
  void markAllAsRead() {
    if (state.unreadCount == 0 &&
        state.notifications.every((notification) => notification.isRead)) {
      return;
    }

    emit(
      state.copyWith(
        notifications: state.notifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList(),
        unreadCount: 0,
      ),
    );

    unawaited(_apiService.markAllAsRead().catchError((_) {}));
  }

  /// Optimistically removes a notification, then syncs with the API.
  void removeNotification(String id) {
    final matches = state.notifications.where((n) => n.id == id).toList();
    if (matches.isEmpty) return;
    final target = matches.first;

    emit(
      state.copyWith(
        notifications: state.notifications
            .where((notification) => notification.id != id)
            .toList(),
        unreadCount: target.isRead
            ? state.unreadCount
            : max(0, state.unreadCount - 1),
      ),
    );

    unawaited(_apiService.deleteNotification(id).catchError((_) {}));
  }

  /// Optimistically clears everything, then syncs with the API.
  void clearAll() {
    emit(state.copyWith(notifications: [], unreadCount: 0));
    unawaited(_apiService.clearAll().catchError((_) {}));
  }

  @override
  Future<void> close() {
    unawaited(_answerScoreOverriddenController.close());
    return super.close();
  }
}
