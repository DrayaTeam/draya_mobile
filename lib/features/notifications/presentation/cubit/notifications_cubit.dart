import "dart:async";

import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/core/signalr/signalr_events.dart";
import "package:draya_mobile/core/signalr/signalr_service.dart";
import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class NotificationsCubit extends Cubit<NotificationsState> {
  final SignalRService _signalRService;

  static const String _reportsHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/reports-notification";
  static const String _examGenerationHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/exam-generation";

  bool _initialized = false;

  NotificationsCubit(this._signalRService) : super(const NotificationsState()) {
    _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    _signalRService.onReceiveGenerationProgress(
      _handleExamGenerationProgress,
    );
    _signalRService.onReportGenerated(_handleReportGenerated);
    _signalRService.onStudentAtRisk(_handleStudentAtRisk);

    await ensureConnected();
  }

  /// Connects the notification hub matching the current user role.
  /// Safe to call multiple times; skips if already connected to the hub.
  Future<void> ensureConnected() async {
    try {
      final role = await AppTokenHelper.getUserRole();
      final hubUrl = role == "Teacher" ? _reportsHubUrl : _examGenerationHubUrl;

      final token = await AppTokenHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      await _signalRService.connect(hubUrl: hubUrl, token: token);
      emit(state.copyWith(isConnected: true));
    } catch (_) {
      emit(state.copyWith(isConnected: false));
    }
  }

  void _handleExamGenerationProgress(ExamGenerationProgressEvent event) {
    if (event.isCompleted && event.examId != null) {
      _addNotification(
        AppNotification(
          id: "exam-generation-${event.generationId}-${DateTime.now().millisecondsSinceEpoch}",
          title: "امتحانك التدريبي جاهز",
          message: "تم إنشاء الامتحان التدريبي بالذكاء الاصطناعي بنجاح، يمكنك البدء الآن.",
          type: AppNotificationType.examGeneration,
          createdAt: DateTime.now(),
        ),
      );
    } else if (event.isFailed) {
      _addNotification(
        AppNotification(
          id: "exam-generation-failed-${event.generationId}-${DateTime.now().millisecondsSinceEpoch}",
          title: "فشل توليد الامتحان",
          message:
              event.errorMessage ?? "تعذر إنشاء الامتحان التدريبي، حاول مرة أخرى.",
          type: AppNotificationType.examGeneration,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  void _handleReportGenerated(ReportGeneratedEvent event) {
    _addNotification(
      AppNotification(
        id: "report-${event.reportId}",
        title: "تقرير أداء جديد",
        message: "يتوفر تقرير أداء جديد بانتظار مراجعتك واعتماده.",
        type: AppNotificationType.reportGenerated,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _handleStudentAtRisk(StudentAtRiskEvent event) {
    _addNotification(
      AppNotification(
        id: "at-risk-${event.studentId}-${event.topicName}-${DateTime.now().millisecondsSinceEpoch}",
        title: "تنبيه: طالب متعثر",
        message: "أحد الطلاب يعاني صعوبة في ${event.topicName}.",
        type: AppNotificationType.studentAtRisk,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _addNotification(AppNotification notification) {
    final updated = [notification, ...state.notifications];
    emit(state.copyWith(notifications: updated));
  }

  void markAsRead(String id) {
    final updated = state.notifications
        .map(
          (notification) =>
              notification.id == id
              ? notification.copyWith(isRead: true)
              : notification,
        )
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void markAllAsRead() {
    final updated = state.notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void removeNotification(String id) {
    final updated = state.notifications
        .where((notification) => notification.id != id)
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void clearAll() {
    emit(state.copyWith(notifications: []));
  }
}
