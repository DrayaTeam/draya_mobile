import "dart:async";

import "package:draya_mobile/core/signalr/signalr_events.dart";
import "package:draya_mobile/core/signalr/signalr_service.dart";
import "package:signalr_netcore/hub_connection.dart";
import "package:signalr_netcore/hub_connection_builder.dart";
import "package:signalr_netcore/http_connection_options.dart";


class SignalRClientService implements SignalRService {
  HubConnection? _connection;
  String? _currentHubUrl;

  /// Long-lived secondary hubs (e.g. notification hubs) keyed by name.
  final Map<String, HubConnection> _backgroundConnections = {};
  final Map<String, String> _backgroundUrls = {};

  final Map<String, List<Function>> _listeners = {};

  @override
  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  Iterable<HubConnection> get _allConnections sync* {
    final primary = _connection;
    if (primary != null) yield primary;
    yield* _backgroundConnections.values;
  }

  @override
  Future<void> connect({required String hubUrl, required String token}) async {
    if (isConnected && _currentHubUrl == hubUrl) return;

    await disconnect();
    _currentHubUrl = hubUrl;
    _connection = _buildConnection(hubUrl, token);

    _bindAllEvents();
    await _connection!.start();
  }

  @override
  Future<void> connectBackgroundHub({
    required String key,
    required String hubUrl,
    required String token,
  }) async {
    final existing = _backgroundConnections[key];
    if (existing != null &&
        existing.state == HubConnectionState.Connected &&
        _backgroundUrls[key] == hubUrl) {
      return;
    }
    if (existing != null) {
      try {
        await existing.stop();
      } catch (_) {}
      _backgroundConnections.remove(key);
      _backgroundUrls.remove(key);
    }

    final connection = _buildConnection(hubUrl, token);
    _backgroundConnections[key] = connection;
    _backgroundUrls[key] = hubUrl;
    for (final eventName in _listeners.keys) {
      _bindOn(connection, eventName);
    }
    await connection.start();
  }

  @override
  Future<void> disconnectBackgroundHub(String key) async {
    final connection = _backgroundConnections.remove(key);
    _backgroundUrls.remove(key);
    if (connection != null) {
      try {
        await connection.stop();
      } catch (_) {}
    }
  }

  @override
  Future<void> disconnectAllBackgroundHubs() async {
    for (final key in List<String>.from(_backgroundConnections.keys)) {
      await disconnectBackgroundHub(key);
    }
  }

  HubConnection _buildConnection(String hubUrl, String token) {
    return HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .withAutomaticReconnect()
        .build();
  }

  @override
  Future<void> disconnect() async {
    final connection = _connection;
    _connection = null;
    _currentHubUrl = null;
    if (connection != null) {
      await connection.stop();
    }
  }

  @override
  Future<void> joinClassroom(String classroomId) =>
      _invoke("JoinClassroom", classroomId);

  @override
  Future<void> leaveClassroom(String classroomId) =>
      _invoke("LeaveClassroom", classroomId);

  @override
  Future<void> joinGradingGroup(String gradingJobId) =>
      _invoke("JoinGradingGroup", gradingJobId);

  Future<void> _invoke(String method, String groupId) async {
    for (final connection in _allConnections.toList()) {
      if (connection.state == HubConnectionState.Connected) {
        try {
          await connection.invoke(method, args: [groupId]);
          return;
        } catch (_) {}
      }
    }
  }

  @override
  void onQuestionCreated(void Function(QuestionCreatedEvent) callback) {
    _addListener("QuestionCreated", callback);
  }

  @override
  void onQuestionReplied(void Function(QuestionRepliedEvent) callback) {
    _addListener("QuestionReplied", callback);
  }

  @override
  void onQuestionVoteUpdated(void Function(QuestionVoteUpdatedEvent) callback) {
    _addListener("QuestionVoteUpdated", callback);
  }

  @override
  void onReceiveGenerationProgress(
    void Function(ExamGenerationProgressEvent) callback,
  ) {
    _addListener("ReceiveGenerationProgress", callback);
  }

  @override
  void onReportGenerated(void Function(ReportGeneratedEvent) callback) {
    _addListener("ReportGenerated", callback);
  }

  @override
  void onStudentAtRisk(void Function(StudentAtRiskEvent) callback) {
    _addListener("StudentAtRisk", callback);
  }

  @override
  void onGradingProgressUpdated(
    void Function(GradingProgressEvent) callback,
  ) {
    _addListener("GradingProgressUpdated", callback);
  }

  @override
  void onMaterialParsed(void Function(MaterialParsedEvent) callback) {
    _addListener("MaterialParsed", callback);
  }

  @override
  void onReceiveNotification(
    void Function(NotificationReceivedEvent) callback,
  ) {
    _addListener("ReceiveNotification", callback);
  }

  @override
  void onAnswerScoreOverridden(
    void Function(AnswerScoreOverriddenEvent) callback,
  ) {
    _addListener("AnswerScoreOverridden", callback);
  }

  void _addListener(String eventName, Function callback) {
    _listeners.putIfAbsent(eventName, () => []).add(callback);
    _bindEvent(eventName);
  }

  void _bindAllEvents() {
    for (final eventName in _listeners.keys) {
      for (final connection in _allConnections) {
        _bindOn(connection, eventName);
      }
    }
  }

  void _bindEvent(String eventName) {
    for (final connection in _allConnections.toList()) {
      _bindOn(connection, eventName);
    }
  }

  void _bindOn(HubConnection connection, String eventName) {
    connection.off(eventName);
    connection.on(eventName, (arguments) {
      if (arguments == null || arguments.isEmpty || arguments.first is! Map) {
        return;
      }
      final payload = Map<String, dynamic>.from(arguments.first as Map);
      final event = switch (eventName) {
        "QuestionCreated" => QuestionCreatedEvent.fromJson(payload),
        "QuestionReplied" => QuestionRepliedEvent.fromJson(payload),
        "QuestionVoteUpdated" => QuestionVoteUpdatedEvent.fromJson(payload),
        "ReceiveGenerationProgress" =>
          ExamGenerationProgressEvent.fromJson(payload),
        "GradingProgressUpdated" => GradingProgressEvent.fromJson(payload),
        "MaterialParsed" => MaterialParsedEvent.fromJson(payload),
        "ReportGenerated" => ReportGeneratedEvent.fromJson(payload),
        "StudentAtRisk" => StudentAtRiskEvent.fromJson(payload),
        "ReceiveNotification" => NotificationReceivedEvent.fromJson(payload),
        "AnswerScoreOverridden" => AnswerScoreOverriddenEvent.fromJson(payload),
        _ => null,
      };
      if (event == null) return;

      for (final listener in List<Function>.from(_listeners[eventName] ?? [])) {
        listener(event);
      }
    });
  }

  @override
  void offEvent(String eventName) {
    _listeners.remove(eventName);
    _connection?.off(eventName);
    for (final connection in _backgroundConnections.values) {
      connection.off(eventName);
    }
  }

  @override
  void removeListener(String eventName, Function callback) {
    final listeners = _listeners[eventName];
    if (listeners == null) return;
    listeners.remove(callback);
    if (listeners.isEmpty) {
      _listeners.remove(eventName);
      for (final connection in _allConnections.toList()) {
        try {
          connection.off(eventName);
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _listeners.clear();
    for (final connection in _backgroundConnections.values) {
      unawaited(connection.stop());
    }
    _backgroundConnections.clear();
    _backgroundUrls.clear();
    unawaited(disconnect());
  }
}
