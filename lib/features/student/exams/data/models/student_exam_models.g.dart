// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_exam_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttemptSummaryModel _$AttemptSummaryModelFromJson(Map<String, dynamic> json) =>
    AttemptSummaryModel(
      id: json['id'] as String,
      finalScore: (json['finalScore'] as num?)?.toDouble() ?? 0.0,
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 0.0,
      needsTeacherReview: json['needsTeacherReview'] as bool? ?? false,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
    );

Map<String, dynamic> _$AttemptSummaryModelToJson(
  AttemptSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'finalScore': instance.finalScore,
  'maxScore': instance.maxScore,
  'needsTeacherReview': instance.needsTeacherReview,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
};

StudentExamOverviewModel _$StudentExamOverviewModelFromJson(
  Map<String, dynamic> json,
) => StudentExamOverviewModel(
  id: json['id'] as String,
  classroomId: json['classroomId'] as String,
  sectionId: json['sectionId'] as String?,
  title: json['title'] as String,
  topic: json['topic'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  allowedAttempts: (json['allowedAttempts'] as num?)?.toInt(),
  hasSubmitted: json['hasSubmitted'] as bool? ?? false,
  attemptStatus: json['attemptStatus'] as String?,
  latestScore: (json['latestScore'] as num?)?.toDouble(),
  maxScore: (json['maxScore'] as num?)?.toDouble(),
  usedAttempts: (json['usedAttempts'] as num?)?.toInt() ?? 0,
  attempts:
      (json['attempts'] as List<dynamic>?)
          ?.map((e) => AttemptSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$StudentExamOverviewModelToJson(
  StudentExamOverviewModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'classroomId': instance.classroomId,
  'sectionId': instance.sectionId,
  'title': instance.title,
  'topic': instance.topic,
  'durationMinutes': instance.durationMinutes,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'allowedAttempts': instance.allowedAttempts,
  'createdAt': instance.createdAt.toIso8601String(),
  'hasSubmitted': instance.hasSubmitted,
  'attemptStatus': instance.attemptStatus,
  'latestScore': instance.latestScore,
  'maxScore': instance.maxScore,
  'usedAttempts': instance.usedAttempts,
  'attempts': instance.attempts,
};

StudentExamsPageModel _$StudentExamsPageModelFromJson(
  Map<String, dynamic> json,
) => StudentExamsPageModel(
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => StudentExamOverviewModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$StudentExamsPageModelToJson(
  StudentExamsPageModel instance,
) => <String, dynamic>{'items': instance.items};

QuestionOptionModel _$QuestionOptionModelFromJson(Map<String, dynamic> json) =>
    QuestionOptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool?,
    );

Map<String, dynamic> _$QuestionOptionModelToJson(
  QuestionOptionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'isCorrect': instance.isCorrect,
};

ExamQuestionModel _$ExamQuestionModelFromJson(Map<String, dynamic> json) =>
    ExamQuestionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      rubric: json['rubric'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map(
                (e) => QuestionOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExamQuestionModelToJson(ExamQuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
      'difficulty': instance.difficulty,
      'rubric': instance.rubric,
      'options': instance.options,
    };

StudentExamModel _$StudentExamModelFromJson(Map<String, dynamic> json) =>
    StudentExamModel(
      id: json['id'] as String,
      classroomId: json['classroomId'] as String,
      sectionId: json['sectionId'] as String?,
      title: json['title'] as String,
      topic: json['topic'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      allowedAttempts: (json['allowedAttempts'] as num?)?.toInt(),
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map(
                (e) => ExamQuestionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$StudentExamModelToJson(StudentExamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classroomId': instance.classroomId,
      'sectionId': instance.sectionId,
      'title': instance.title,
      'topic': instance.topic,
      'createdAt': instance.createdAt.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'allowedAttempts': instance.allowedAttempts,
      'questions': instance.questions,
    };
