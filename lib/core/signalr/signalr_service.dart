import "package:draya_mobile/core/signalr/signalr_events.dart";

abstract class SignalRService {
  Future<void> connect({required String hubUrl, required String token});
  Future<void> disconnect();

  /// Connects an additional long-lived hub without dropping the primary
  /// connection (used by notification hubs that run app-wide).
  Future<void> connectBackgroundHub({
    required String key,
    required String hubUrl,
    required String token,
  });

  Future<void> disconnectBackgroundHub(String key);

  Future<void> disconnectAllBackgroundHubs();

  bool get isConnected;

  Future<void> joinClassroom(String classroomId);

  Future<void> leaveClassroom(String classroomId);

  Future<void> joinGradingGroup(String gradingJobId);

  void onQuestionCreated(Function(QuestionCreatedEvent) callback);

  void onQuestionReplied(Function(QuestionRepliedEvent) callback);

  void onQuestionVoteUpdated(Function(QuestionVoteUpdatedEvent) callback);

  void onReceiveGenerationProgress(
    Function(ExamGenerationProgressEvent) callback,
  );

  void onReportGenerated(Function(ReportGeneratedEvent) callback);

  void onStudentAtRisk(Function(StudentAtRiskEvent) callback);

  void onGradingProgressUpdated(Function(GradingProgressEvent) callback);

  void onMaterialParsed(Function(MaterialParsedEvent) callback);

  /// Unified notification hub event (ReceiveNotification).
  void onReceiveNotification(Function(NotificationReceivedEvent) callback);

  /// Fired on the notifications hub when a teacher overrides an answer score.
  void onAnswerScoreOverridden(Function(AnswerScoreOverriddenEvent) callback);

  void offEvent(String eventName);

  void dispose();
}
