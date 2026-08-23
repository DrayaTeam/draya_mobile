// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attempt_review_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttemptReviewGradingModel _$AttemptReviewGradingModelFromJson(
  Map<String, dynamic> json,
) => AttemptReviewGradingModel(
  score: (json['score'] as num?)?.toDouble() ?? 0.0,
  maxScore: (json['maxScore'] as num?)?.toDouble() ?? 1.0,
  isAiGraded: json['isAiGraded'] as bool? ?? false,
  needsTeacherReview: json['needsTeacherReview'] as bool? ?? false,
  isFinalized: json['isFinalized'] as bool? ?? true,
  rationale: json['rationale'] as String?,
  reviewedByTeacherId: json['reviewedByTeacherId'] as String?,
  teacherOverrideScore: (json['teacherOverrideScore'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AttemptReviewGradingModelToJson(
  AttemptReviewGradingModel instance,
) => <String, dynamic>{
  'score': instance.score,
  'maxScore': instance.maxScore,
  'isAiGraded': instance.isAiGraded,
  'needsTeacherReview': instance.needsTeacherReview,
  'isFinalized': instance.isFinalized,
  'rationale': instance.rationale,
  'reviewedByTeacherId': instance.reviewedByTeacherId,
  'teacherOverrideScore': instance.teacherOverrideScore,
};

AttemptAnswerModel _$AttemptAnswerModelFromJson(Map<String, dynamic> json) =>
    AttemptAnswerModel(
      answerId: json['answerId'] as String?,
      examQuestionId: json['examQuestionId'] as String,
      questionText: json['questionText'] as String?,
      questionType: json['questionType'] as String?,
      rubric: json['rubric'] as String?,
      answerText: json['answerText'] as String?,
      selectedOptionId: json['selectedOptionId'] as String?,
      gradingResult: json['gradingResult'] == null
          ? null
          : AttemptReviewGradingModel.fromJson(
              json['gradingResult'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AttemptAnswerModelToJson(AttemptAnswerModel instance) =>
    <String, dynamic>{
      'answerId': instance.answerId,
      'examQuestionId': instance.examQuestionId,
      'questionText': instance.questionText,
      'questionType': instance.questionType,
      'rubric': instance.rubric,
      'answerText': instance.answerText,
      'selectedOptionId': instance.selectedOptionId,
      'gradingResult': instance.gradingResult,
    };

AttemptReviewResultsModel _$AttemptReviewResultsModelFromJson(
  Map<String, dynamic> json,
) => AttemptReviewResultsModel(
  attemptId: json['attemptId'] as String?,
  examId: json['examId'] as String?,
  examTitle: json['examTitle'] as String?,
  maxScore: (json['maxScore'] as num?)?.toDouble() ?? 0.0,
  finalScore: (json['finalScore'] as num?)?.toDouble() ?? 0.0,
  isSubmitted: json['isSubmitted'] as bool? ?? true,
  submittedAt: json['submittedAt'] == null
      ? null
      : DateTime.parse(json['submittedAt'] as String),
  needsTeacherReview: json['needsTeacherReview'] as bool? ?? false,
  answers:
      (json['answers'] as List<dynamic>?)
          ?.map((e) => AttemptAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AttemptReviewResultsModelToJson(
  AttemptReviewResultsModel instance,
) => <String, dynamic>{
  'attemptId': instance.attemptId,
  'examId': instance.examId,
  'examTitle': instance.examTitle,
  'maxScore': instance.maxScore,
  'finalScore': instance.finalScore,
  'isSubmitted': instance.isSubmitted,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'needsTeacherReview': instance.needsTeacherReview,
  'answers': instance.answers,
};

OverrideAnswerScoreRequestModel _$OverrideAnswerScoreRequestModelFromJson(
  Map<String, dynamic> json,
) => OverrideAnswerScoreRequestModel(
  newScore: (json['newScore'] as num).toDouble(),
);

Map<String, dynamic> _$OverrideAnswerScoreRequestModelToJson(
  OverrideAnswerScoreRequestModel instance,
) => <String, dynamic>{'newScore': instance.newScore};
