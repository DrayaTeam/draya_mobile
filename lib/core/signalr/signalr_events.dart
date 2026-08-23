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

class ExamGenerationProgressEvent extends SignalREvent {
  final String generationId;
  final String status;
  final String? errorMessage;
  final String? examId;

  const ExamGenerationProgressEvent({
    required this.generationId,
    required this.status,
    this.errorMessage,
    this.examId,
  });

  factory ExamGenerationProgressEvent.fromJson(Map<String, dynamic> json) {
    return ExamGenerationProgressEvent(
      generationId:
          (json["GenerationId"] ?? json["generationId"] ?? "").toString(),
      status: (json["Status"] ?? json["status"] ?? "Pending").toString(),
      errorMessage: json["ErrorMessage"]?.toString() ??
          json["errorMessage"]?.toString(),
      examId: json["ExamId"]?.toString() ?? json["examId"]?.toString(),
    );
  }

  bool get isCompleted => status.toLowerCase() == "completed";
  bool get isFailed => status.toLowerCase() == "failed";
  bool get isGenerating => status.toLowerCase() == "generating";
}

class GradingProgressEvent extends SignalREvent {
  final String gradingJobId;
  final String status;
  final String? errorMessage;
  final double? finalScore;
  final bool needsTeacherReview;

  const GradingProgressEvent({
    required this.gradingJobId,
    required this.status,
    this.errorMessage,
    this.finalScore,
    this.needsTeacherReview = false,
  });

  factory GradingProgressEvent.fromJson(Map<String, dynamic> json) {
    return GradingProgressEvent(
      gradingJobId:
          (json["GradingJobId"] ?? json["gradingJobId"] ?? "").toString(),
      status: (json["Status"] ?? json["status"] ?? "Pending").toString(),
      errorMessage: json["ErrorMessage"]?.toString() ??
          json["errorMessage"]?.toString(),
      finalScore:
          (json["FinalScore"] ?? json["finalScore"]) is num
          ? (json["FinalScore"] ?? json["finalScore"]).toDouble()
          : null,
      needsTeacherReview:
          json["NeedsTeacherReview"] as bool? ??
          json["needsTeacherReview"] as bool? ??
          false,
    );
  }

  bool get isCompleted => status.toLowerCase() == "completed";
  bool get isFailed => status.toLowerCase() == "failed";
}

class MaterialParsedEvent extends SignalREvent {
  final String materialId;
  final String versionId;
  final String status;
  final String message;

  const MaterialParsedEvent({
    required this.materialId,
    required this.versionId,
    required this.status,
    required this.message,
  });

  factory MaterialParsedEvent.fromJson(Map<String, dynamic> json) {
    return MaterialParsedEvent(
      materialId:
          (json["MaterialId"] ?? json["materialId"] ?? "").toString(),
      versionId:
          (json["VersionId"] ?? json["versionId"] ?? "").toString(),
      status: (json["Status"] ?? json["status"] ?? "").toString(),
      message: (json["Message"] ?? json["message"] ?? "").toString(),
    );
  }

  bool get isSuccess => status.toLowerCase() == "success";
  bool get isFailed => status.toLowerCase() == "failed";
}

class ReportGeneratedEvent extends SignalREvent {
  final String reportId;
  final String studentId;

  const ReportGeneratedEvent({
    required this.reportId,
    required this.studentId,
  });

  factory ReportGeneratedEvent.fromJson(Map<String, dynamic> json) {
    return ReportGeneratedEvent(
      reportId:
          (json["ReportId"] ?? json["reportId"] ?? "").toString(),
      studentId:
          (json["StudentId"] ?? json["studentId"] ?? "").toString(),
    );
  }
}

class StudentAtRiskEvent extends SignalREvent {
  final String studentId;
  final String topicName;

  const StudentAtRiskEvent({
    required this.studentId,
    required this.topicName,
  });

  factory StudentAtRiskEvent.fromJson(Map<String, dynamic> json) {
    return StudentAtRiskEvent(
      studentId:
          (json["StudentId"] ?? json["studentId"] ?? "").toString(),
      topicName:
          (json["TopicName"] ?? json["topicName"] ?? "").toString(),
    );
  }
}

