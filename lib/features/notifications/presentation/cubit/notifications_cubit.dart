import "dart:async";

import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/core/services/local_notification_service.dart";
import "package:draya_mobile/core/signalr/signalr_events.dart";
import "package:draya_mobile/core/signalr/signalr_service.dart";
import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";
import "package:draya_mobile/features/notifications/presentation/cubit/notifications_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class NotificationsCubit extends Cubit<NotificationsState> {
  final SignalRService _signalRService;
  final LocalNotificationService _localNotifications;

  static const String _reportsHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/reports";
  static const String _materialsHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/materials";
  static const String _examGradingHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/exam-grading";
  static const String _examGenerationHubUrl =
      "${ApiConstants.baseUrlWithoutV1}hubs/exam-generation";

  static const String _reportsHubKey = "reports";
  static const String _materialsHubKey = "materials";
  static const String _examGradingHubKey = "exam-grading";
  static const String _examGenerationHubKey = "exam-generation";

  bool _initialized = false;

  NotificationsCubit(
    this._signalRService,
    this._localNotifications,
  ) : super(const NotificationsState()) {
    _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    _signalRService.onReceiveGenerationProgress(
      _handleExamGenerationProgress,
    );
    _signalRService.onGradingProgressUpdated(_handleGradingProgress);
    _signalRService.onMaterialParsed(_handleMaterialParsed);
    _signalRService.onReportGenerated(_handleReportGenerated);
    _signalRService.onStudentAtRisk(_handleStudentAtRisk);

    await ensureConnected();
  }

  /// Connects to all notification hubs matching the current user role.
  ///
  /// Hubs are attached as background connections so they never clash with
  /// the primary SignalR connection used by the classroom Q&A features.
  /// Safe to call multiple times; skips hubs that are already connected.
  Future<void> ensureConnected() async {
    try {
      final role = await AppTokenHelper.getUserRole();
      final token = await AppTokenHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      await _connectHubs(
        role == "Teacher"
            ? {
                _reportsHubKey: _reportsHubUrl,
                _materialsHubKey: _materialsHubUrl,
              }
            : {_examGenerationHubKey: _examGenerationHubUrl},
        token,
      );

      // Exam grading updates apply to both roles.
      await _connectHubs({_examGradingHubKey: _examGradingHubUrl}, token);

      emit(state.copyWith(isConnected: true));
    } catch (_) {
      emit(state.copyWith(isConnected: false));
    }
  }

  /// Connects the given hubs (no-op for hubs that are already connected).
  Future<void> _connectHubs(
    Map<String, String> hubs,
    String token,
  ) async {
    for (final entry in hubs.entries) {
      await _signalRService.connectBackgroundHub(
        key: entry.key,
        hubUrl: entry.value,
        token: token,
      );
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

  void _handleGradingProgress(GradingProgressEvent event) {
    if (event.isCompleted) {
      final scorePart =
          event.finalScore != null ? " درجتك: ${_formatScore(event.finalScore!)}." : "";
      final reviewPart =
          event.needsTeacherReview
          ? " إجاباتك المقالية بانتظار مراجعة المعلم."
          : "";
      _addNotification(
        AppNotification(
          id: "exam-grading-${event.gradingJobId}",
          title: "تم تصحيح امتحانك",
          message: "انتهى تصحيح الامتحان بالذكاء الاصطناعي.$scorePart$reviewPart",
          type: AppNotificationType.examGrading,
          createdAt: DateTime.now(),
        ),
      );
    } else if (event.isFailed) {
      _addNotification(
        AppNotification(
          id: "exam-grading-failed-${event.gradingJobId}-${DateTime.now().millisecondsSinceEpoch}",
          title: "فشل تصحيح الامتحان",
          message:
              event.errorMessage ?? "تعذر تصحيح الامتحان، سيتم إعادة المحاولة تلقائيًا.",
          type: AppNotificationType.examGrading,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  void _handleMaterialParsed(MaterialParsedEvent event) {
    if (event.isSuccess) {
      _addNotification(
        AppNotification(
          id: "material-parsed-${event.materialId}-${event.versionId}",
          title: "تمت معالجة الملف",
          message: event.message.isNotEmpty
              ? event.message
              : "انتهت معالجة الملف بالذكاء الاصطناعي وأصبح جاهزًا للاستخدام.",
          type: AppNotificationType.materialParsed,
          createdAt: DateTime.now(),
        ),
      );
    } else if (event.isFailed) {
      _addNotification(
        AppNotification(
          id: "material-parsed-failed-${event.materialId}-${event.versionId}-${DateTime.now().millisecondsSinceEpoch}",
          title: "فشلت معالجة الملف",
          message:
              event.message.isNotEmpty ? event.message : "تعذرت معالجة الملف، حاول رفعه مرة أخرى.",
          type: AppNotificationType.materialParsed,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  String _formatScore(double score) =>
      score % 1 == 0 ? score.toStringAsFixed(0) : score.toStringAsFixed(1);

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
    unawaited(
      _localNotifications.show(
        title: notification.title,
        body: notification.message,
      ),
    );

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
