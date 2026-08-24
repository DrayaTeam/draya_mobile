enum QuestionType {
  multipleChoice,
  essay,
  trueFalse,
  fillInTheBlank,
  shortAnswer;

  static QuestionType fromString(String type) {
    switch (type.toLowerCase().trim()) {
      case "multiplechoice":
      case "mcq":
        return QuestionType.multipleChoice;
      case "essay":
        return QuestionType.essay;
      case "truefalse":
        return QuestionType.trueFalse;
      case "fillintheblank":
        return QuestionType.fillInTheBlank;
      case "shortanswer":
        return QuestionType.shortAnswer;
      default:
        return QuestionType.multipleChoice;
    }
  }

  String toDisplayString() {
    switch (this) {
      case QuestionType.multipleChoice:
        return "اختيار من متعدد";
      case QuestionType.essay:
        return "سؤال مقالي";
      case QuestionType.trueFalse:
        return "صح أم خطأ";
      case QuestionType.fillInTheBlank:
        return "أكمل الفراغ";
      case QuestionType.shortAnswer:
        return "إجابة قصيرة";
    }
  }
}

class QuestionOption {
  final String id;
  final String text;

  const QuestionOption({
    required this.id,
    required this.text,
  });
}

class ExamQuestion {
  final String id;
  final String text;
  final QuestionType type;
  final String difficulty;
  final String? rubric;
  final List<QuestionOption> options;

  const ExamQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.difficulty,
    this.rubric,
    this.options = const [],
  });

  bool get isObjective =>
      type == QuestionType.multipleChoice || type == QuestionType.trueFalse;
}

class ExamAttemptSummary {
  final String id;
  final double finalScore;
  final double maxScore;
  final bool needsTeacherReview;
  final DateTime? submittedAt;
  final DateTime? startedAt;

  const ExamAttemptSummary({
    required this.id,
    this.finalScore = 0.0,
    this.maxScore = 0.0,
    this.needsTeacherReview = false,
    this.submittedAt,
    this.startedAt,
  });

  DateTime get sortDate => submittedAt ?? startedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  double get scorePercentage => maxScore > 0 ? (finalScore / maxScore) * 100 : 0.0;
}

class StudentExamOverview {
  final String id;
  final String classroomId;
  final String? sectionId;
  final String title;
  final String topic;
  final int? allowedAttempts;
  final int usedAttempts;
  final bool hasSubmitted;
  final String? attemptStatus;
  final double? latestScore;
  final double? maxScore;
  final List<ExamAttemptSummary> attempts;

  const StudentExamOverview({
    required this.id,
    required this.classroomId,
    this.sectionId,
    this.title = "",
    this.topic = "",
    this.allowedAttempts,
    this.usedAttempts = 0,
    this.hasSubmitted = false,
    this.attemptStatus,
    this.latestScore,
    this.maxScore,
    this.attempts = const [],
  });

  bool get hasAttemptsLeft =>
      allowedAttempts == null || usedAttempts < allowedAttempts!;

  bool get hasViewableResult =>
      hasSubmitted && latestAttempt != null;

  ExamAttemptSummary? get latestAttempt {
    if (attempts.isEmpty) return null;
    final sorted = List<ExamAttemptSummary>.from(attempts)
      ..sort((a, b) => b.sortDate.compareTo(a.sortDate));
    return sorted.first;
  }
}

class StudentExam {
  final String id;
  final String classroomId;
  final String? sectionId;
  final String title;
  final String topic;
  final DateTime createdAt;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;
  final List<ExamQuestion> questions;

  const StudentExam({
    required this.id,
    required this.classroomId,
    this.sectionId,
    required this.title,
    required this.topic,
    required this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
    this.questions = const [],
  });
}

class GradingResult {
  final double score;
  final double maxScore;
  final double? confidenceScore;
  final bool isAiGraded;
  final bool needsTeacherReview;
  final String? rationale;
  final double? teacherOverrideScore;

  const GradingResult({
    required this.score,
    required this.maxScore,
    this.confidenceScore,
    required this.isAiGraded,
    required this.needsTeacherReview,
    this.rationale,
    this.teacherOverrideScore,
  });
}

class GradedAnswer {
  final String? answerId;
  final String examQuestionId;
  final String? answerText;
  final String? selectedOptionId;
  final GradingResult? gradingResult;

  const GradedAnswer({
    this.answerId,
    required this.examQuestionId,
    this.answerText,
    this.selectedOptionId,
    this.gradingResult,
  });
}

class ExamAttemptResult {
  final String attemptId;
  final String examId;
  final bool isSubmitted;
  final DateTime? submittedAt;
  final double finalScore;
  final double? maxScore;
  final bool needsTeacherReview;
  final List<GradedAnswer> answers;

  const ExamAttemptResult({
    required this.attemptId,
    required this.examId,
    required this.isSubmitted,
    this.submittedAt,
    required this.finalScore,
    this.maxScore,
    required this.needsTeacherReview,
    this.answers = const [],
  });

  double get maxPossibleScore {
    if (maxScore != null && maxScore! > 0) return maxScore!;
    return answers.fold<double>(
      0.0,
      (sum, a) => sum + (a.gradingResult?.maxScore ?? 1.0),
    );
  }

  double get scorePercentage =>
      maxPossibleScore > 0 ? (finalScore / maxPossibleScore) * 100 : 0.0;
}

enum GradingJobState {
  pending,
  grading,
  completed,
  completedWithWarning,
  failed,
  unknown;

  static GradingJobState fromString(String? status) {
    switch (status?.toLowerCase().trim()) {
      case "pending":
        return GradingJobState.pending;
      case "grading":
        return GradingJobState.grading;
      case "completed":
        return GradingJobState.completed;
      case "completedwithwarning":
        return GradingJobState.completedWithWarning;
      case "failed":
        return GradingJobState.failed;
      default:
        return GradingJobState.unknown;
    }
  }

  bool get isFinished =>
      this == GradingJobState.completed ||
      this == GradingJobState.completedWithWarning ||
      this == GradingJobState.failed;
}

class GradingJobStatus {
  final String id;
  final String? studentExamAttemptId;
  final GradingJobState status;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final String? errorMessage;

  const GradingJobStatus({
    required this.id,
    this.studentExamAttemptId,
    required this.status,
    this.createdAt,
    this.completedAt,
    this.errorMessage,
  });
}

class SubmitAttemptResponse {
  final String? gradingJobId;
  final String? attemptId;
  final String? message;

  const SubmitAttemptResponse({
    this.gradingJobId,
    this.attemptId,
    this.message,
  });
}

