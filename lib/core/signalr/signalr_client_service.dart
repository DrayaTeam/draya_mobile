import 'dart:async';

import 'package:draya_mobile/core/signalr/signalr_events.dart';
import 'package:draya_mobile/core/signalr/signalr_service.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/http_connection_options.dart';


class SignalRClientService implements SignalRService {
  HubConnection? _connection;
  final Map<String, List<Function>> _listeners = {};

  @override
  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  @override
  Future<void> connect({required String hubUrl, required String token}) async {
    if (isConnected) return;

    await disconnect();
    _connection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _bindAllEvents();
    await _connection!.start();
  }

  @override
  Future<void> disconnect() async {
    final connection = _connection;
    _connection = null;
    if (connection != null) {
      await connection.stop();
    }
  }

  @override
  Future<void> joinClassroom(String classroomId) =>
      _invoke('JoinClassroom', classroomId);

  @override
  Future<void> leaveClassroom(String classroomId) =>
      _invoke('LeaveClassroom', classroomId);

  Future<void> _invoke(String method, String classroomId) async {
    if (!isConnected) return;
    await _connection!.invoke(method, args: [classroomId]);
  }

  @override
  void onQuestionCreated(void Function(QuestionCreatedEvent) callback) {
    _addListener('QuestionCreated', callback);
  }

  @override
  void onQuestionReplied(void Function(QuestionRepliedEvent) callback) {
    _addListener('QuestionReplied', callback);
  }

  @override
  void onQuestionVoteUpdated(void Function(QuestionVoteUpdatedEvent) callback) {
    _addListener('QuestionVoteUpdated', callback);
  }

  void _addListener(String eventName, Function callback) {
    _listeners.putIfAbsent(eventName, () => []).add(callback);
    _bindEvent(eventName);
  }

  void _bindAllEvents() {
    for (final eventName in _listeners.keys) {
      _bindEvent(eventName);
    }
  }

  void _bindEvent(String eventName) {
    final connection = _connection;
    if (connection == null) return;

    connection.off(eventName);
    connection.on(eventName, (arguments) {
      if (arguments == null || arguments.isEmpty || arguments.first is! Map) {
        return;
      }
      final payload = Map<String, dynamic>.from(arguments.first as Map);
      final event = switch (eventName) {
        'QuestionCreated' => QuestionCreatedEvent.fromJson(payload),
        'QuestionReplied' => QuestionRepliedEvent.fromJson(payload),
        'QuestionVoteUpdated' => QuestionVoteUpdatedEvent.fromJson(payload),
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
  }

  @override
  void dispose() {
    _listeners.clear();
    unawaited(disconnect());
  }
}
