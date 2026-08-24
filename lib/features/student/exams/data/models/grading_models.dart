import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:json_annotation/json_annotation.dart";

part "grading_models.g.dart";

@JsonSerializable()
class GradingJobModel {
  final String id;
  final String? studentExamAttemptId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final String? errorMessage;

  const GradingJobModel({
    required this.id,
    this.studentExamAttemptId,
    this.status,
    this.createdAt,
    this.completedAt,
    this.errorMessage,
  });

  factory GradingJobModel.fromJson(Map<String, dynamic> json) =>
      _$GradingJobModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradingJobModelToJson(this);

  GradingJobStatus toEntity() => GradingJobStatus(
        id: id,
        studentExamAttemptId: studentExamAttemptId,
        status: GradingJobState.fromString(status),
        createdAt: createdAt,
        completedAt: completedAt,
        errorMessage: errorMessage,
      );
}

@JsonSerializable()
class GradingResultModel {
  @JsonKey(defaultValue: 0.0)
  final double score;
  @JsonKey(defaultValue: 1.0)
  final double maxScore;
  final double? confidenceScore;
  @JsonKey(defaultValue: false)
  final bool isAiGraded;
  @JsonKey(defaultValue: false)
  final bool needsTeacherReview;
  final String? rationale;
  final double? teacherOverrideScore;

  const GradingResultModel({
    this.score = 0.0,
    this.maxScore = 1.0,
    this.confidenceScore,
    this.isAiGraded = false,
    this.needsTeacherReview = false,
    this.rationale,
    this.teacherOverrideScore,
  });

  factory GradingResultModel.fromJson(Map<String, dynamic> json) =>
      _$GradingResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradingResultModelToJson(this);

  GradingResult toEntity() => GradingResult(
        score: score,
        maxScore: maxScore,
        confidenceScore: confidenceScore,
        isAiGraded: isAiGraded,
        needsTeacherReview: needsTeacherReview,
        rationale: rationale,
        teacherOverrideScore: teacherOverrideScore,
      );
}

@JsonSerializable()
class GradedAnswerModel {
  final String? answerId;
  final String examQuestionId;
  final String? answerText;
  final String? selectedOptionId;
  final GradingResultModel? gradingResult;

  const GradedAnswerModel({
    this.answerId,
    required this.examQuestionId,
    this.answerText,
    this.selectedOptionId,
    this.gradingResult,
  });

  factory GradedAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$GradedAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradedAnswerModelToJson(this);

  GradedAnswer toEntity() => GradedAnswer(
        answerId: answerId,
        examQuestionId: examQuestionId,
        answerText: answerText,
        selectedOptionId: selectedOptionId,
        gradingResult: gradingResult?.toEntity(),
      );
}

@JsonSerializable()
class ExamResultModel {
  final String? attemptId;
  final String? examId;
  @JsonKey(defaultValue: true)
  final bool isSubmitted;
  final DateTime? submittedAt;
  @JsonKey(defaultValue: 0.0)
  final double finalScore;
  final double? maxScore;
  @JsonKey(defaultValue: false)
  final bool needsTeacherReview;
  @JsonKey(defaultValue: [])
  final List<GradedAnswerModel> answers;

  const ExamResultModel({
    this.attemptId,
    this.examId,
    this.isSubmitted = true,
    this.submittedAt,
    this.finalScore = 0.0,
    this.maxScore,
    this.needsTeacherReview = false,
    this.answers = const [],
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) =>
      _$ExamResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultModelToJson(this);

  ExamAttemptResult toEntity() => ExamAttemptResult(
        attemptId: attemptId ?? "",
        examId: examId ?? "",
        isSubmitted: isSubmitted,
        submittedAt: submittedAt,
        finalScore: finalScore,
        maxScore: maxScore,
        needsTeacherReview: needsTeacherReview,
        answers: answers.map((e) => e.toEntity()).toList(),
      );
}

