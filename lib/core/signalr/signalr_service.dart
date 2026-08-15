import 'package:draya_mobile/core/signalr/signalr_events.dart';

abstract class SignalRService {
  Future<void> connect({required String hubUrl, required String token});
  Future<void> disconnect();

  bool get isConnected;

  Future<void> joinClassroom(String classroomId);

  Future<void> leaveClassroom(String classroomId);

  void onQuestionCreated(Function(QuestionCreatedEvent) callback);

  void onQuestionReplied(Function(QuestionRepliedEvent) callback);

  void onQuestionVoteUpdated(Function(QuestionVoteUpdatedEvent) callback);

  void offEvent(String eventName);

  void dispose();
}
