// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grading_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradingJobModel _$GradingJobModelFromJson(Map<String, dynamic> json) =>
    GradingJobModel(
      id: json['id'] as String,
      studentExamAttemptId: json['studentExamAttemptId'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$GradingJobModelToJson(GradingJobModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentExamAttemptId': instance.studentExamAttemptId,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };

GradingResultModel _$GradingResultModelFromJson(Map<String, dynamic> json) =>
    GradingResultModel(
      score: (json['score'] as num).toDouble(),
      maxScore: (json['maxScore'] as num).toDouble(),
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      isAiGraded: json['isAiGraded'] as bool,
      needsTeacherReview: json['needsTeacherReview'] as bool,
      rationale: json['rationale'] as String?,
      teacherOverrideScore: (json['teacherOverrideScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GradingResultModelToJson(GradingResultModel instance) =>
    <String, dynamic>{
      'score': instance.score,
      'maxScore': instance.maxScore,
      'confidenceScore': instance.confidenceScore,
      'isAiGraded': instance.isAiGraded,
      'needsTeacherReview': instance.needsTeacherReview,
      'rationale': instance.rationale,
      'teacherOverrideScore': instance.teacherOverrideScore,
    };

GradedAnswerModel _$GradedAnswerModelFromJson(Map<String, dynamic> json) =>
    GradedAnswerModel(
      answerId: json['answerId'] as String?,
      examQuestionId: json['examQuestionId'] as String,
      answerText: json['answerText'] as String?,
      selectedOptionId: json['selectedOptionId'] as String?,
      gradingResult: json['gradingResult'] == null
          ? null
          : GradingResultModel.fromJson(
              json['gradingResult'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$GradedAnswerModelToJson(GradedAnswerModel instance) =>
    <String, dynamic>{
      'answerId': instance.answerId,
      'examQuestionId': instance.examQuestionId,
      'answerText': instance.answerText,
      'selectedOptionId': instance.selectedOptionId,
      'gradingResult': instance.gradingResult,
    };

ExamResultModel _$ExamResultModelFromJson(Map<String, dynamic> json) =>
    ExamResultModel(
      attemptId: json['attemptId'] as String,
      examId: json['examId'] as String,
      isSubmitted: json['isSubmitted'] as bool,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      finalScore: (json['finalScore'] as num).toDouble(),
      needsTeacherReview: json['needsTeacherReview'] as bool,
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map(
                (e) => GradedAnswerModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExamResultModelToJson(ExamResultModel instance) =>
    <String, dynamic>{
      'attemptId': instance.attemptId,
      'examId': instance.examId,
      'isSubmitted': instance.isSubmitted,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'finalScore': instance.finalScore,
      'needsTeacherReview': instance.needsTeacherReview,
      'answers': instance.answers,
    };
