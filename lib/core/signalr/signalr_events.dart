abstract class SignalREvent {
  const SignalREvent();
}

class QuestionCreatedEvent extends SignalREvent {
  final String classroomId;
  final String questionId;
  final String authorId;
  final String content;
  final DateTime createdAt;

  const QuestionCreatedEvent({
    required this.classroomId,
    required this.questionId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  factory QuestionCreatedEvent.fromJson(Map<String, dynamic> json) {
    return QuestionCreatedEvent(
      classroomId: json["classroomId"] as String,
      questionId: json["questionId"] as String,
      authorId: json["authorId"] as String,
      content: json["content"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }
}

class QuestionRepliedEvent extends SignalREvent {
  final String classroomId;
  final String questionId;
  final String replyId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final bool isTeacherAnswer;

  const QuestionRepliedEvent({
    required this.classroomId,
    required this.questionId,
    required this.replyId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.isTeacherAnswer,
  });

  factory QuestionRepliedEvent.fromJson(Map<String, dynamic> json) {
    return QuestionRepliedEvent(
      classroomId: json["classroomId"] as String,
      questionId: json["questionId"] as String,
      replyId: json["replyId"] as String,
      authorId: json["authorId"] as String,
      content: json["content"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
      isTeacherAnswer: json["isTeacherAnswer"] as bool? ?? false,
    );
  }
}

class QuestionVoteUpdatedEvent extends SignalREvent {
  final String classroomId;
  final String questionId;
  final int voteCount;

  const QuestionVoteUpdatedEvent({
    required this.classroomId,
    required this.questionId,
    required this.voteCount,
  });

  factory QuestionVoteUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return QuestionVoteUpdatedEvent(
      classroomId: json["classroomId"] as String,
      questionId: json["questionId"] as String,
      voteCount: json["voteCount"] as int? ?? 0,
    );
  }
}
