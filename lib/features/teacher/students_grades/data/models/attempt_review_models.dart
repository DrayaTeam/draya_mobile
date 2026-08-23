import "package:json_annotation/json_annotation.dart";

part "attempt_review_models.g.dart";

@JsonSerializable()
class AttemptReviewGradingModel {
  @JsonKey(defaultValue: 0.0)
  final double score;
  @JsonKey(defaultValue: 1.0)
  final double maxScore;
  @JsonKey(defaultValue: false)
  final bool isAiGraded;
  @JsonKey(defaultValue: false)
  final bool needsTeacherReview;
  @JsonKey(defaultValue: true)
  final bool isFinalized;
  final String? rationale;
  final String? reviewedByTeacherId;
  final double? teacherOverrideScore;

  const AttemptReviewGradingModel({
    this.score = 0.0,
    this.maxScore = 1.0,
    this.isAiGraded = false,
    this.needsTeacherReview = false,
    this.isFinalized = true,
    this.rationale,
    this.reviewedByTeacherId,
    this.teacherOverrideScore,
  });

  factory AttemptReviewGradingModel.fromJson(Map<String, dynamic> json) =>
      _$AttemptReviewGradingModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttemptReviewGradingModelToJson(this);
}

@JsonSerializable()
class AttemptAnswerModel {
  final String? answerId;
  final String examQuestionId;
  final String? questionText;
  final String? questionType;
  final String? rubric;
  final String? answerText;
  final String? selectedOptionId;
  final AttemptReviewGradingModel? gradingResult;

  const AttemptAnswerModel({
    this.answerId,
    required this.examQuestionId,
    this.questionText,
    this.questionType,
    this.rubric,
    this.answerText,
    this.selectedOptionId,
    this.gradingResult,
  });

  factory AttemptAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AttemptAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttemptAnswerModelToJson(this);
}

@JsonSerializable()
class AttemptReviewResultsModel {
  final String? attemptId;
  final String? examId;
  final String? examTitle;
  @JsonKey(defaultValue: 0.0)
  final double maxScore;
  @JsonKey(defaultValue: 0.0)
  final double finalScore;
  @JsonKey(defaultValue: true)
  final bool isSubmitted;
  final DateTime? submittedAt;
  @JsonKey(defaultValue: false)
  final bool needsTeacherReview;
  @JsonKey(defaultValue: [])
  final List<AttemptAnswerModel> answers;

  const AttemptReviewResultsModel({
    this.attemptId,
    this.examId,
    this.examTitle,
    this.maxScore = 0.0,
    this.finalScore = 0.0,
    this.isSubmitted = true,
    this.submittedAt,
    this.needsTeacherReview = false,
    this.answers = const [],
  });

  factory AttemptReviewResultsModel.fromJson(Map<String, dynamic> json) =>
      _$AttemptReviewResultsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttemptReviewResultsModelToJson(this);
}

@JsonSerializable()
class OverrideAnswerScoreRequestModel {
  @JsonKey(name: "newScore")
  final double newScore;

  const OverrideAnswerScoreRequestModel({required this.newScore});

  factory OverrideAnswerScoreRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$OverrideAnswerScoreRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OverrideAnswerScoreRequestModelToJson(this);
}
