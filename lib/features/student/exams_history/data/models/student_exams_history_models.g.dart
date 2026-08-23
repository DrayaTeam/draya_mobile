// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_exams_history_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttemptSummaryModel _$AttemptSummaryModelFromJson(Map<String, dynamic> json) =>
    AttemptSummaryModel(
      id: json['id'] as String,
      finalScore: (json['finalScore'] as num?)?.toDouble() ?? 0.0,
      needsTeacherReview: json['needsTeacherReview'] as bool? ?? false,
      isFinalized: json['isFinalized'] as bool? ?? false,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );

Map<String, dynamic> _$AttemptSummaryModelToJson(
  AttemptSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'finalScore': instance.finalScore,
  'needsTeacherReview': instance.needsTeacherReview,
  'isFinalized': instance.isFinalized,
  'startedAt': instance.startedAt?.toIso8601String(),
  'submittedAt': instance.submittedAt?.toIso8601String(),
};

StudentExamWithAttemptsModel _$StudentExamWithAttemptsModelFromJson(
  Map<String, dynamic> json,
) => StudentExamWithAttemptsModel(
  id: json['id'] as String,
  title: json['title'] as String,
  classroomId: json['classroomId'] as String?,
  classroomName: json['classroomName'] as String?,
  latestScore: (json['latestScore'] as num?)?.toDouble(),
  usedAttempts: (json['usedAttempts'] as num?)?.toInt() ?? 0,
  allowedAttempts: (json['allowedAttempts'] as num?)?.toInt(),
  hasSubmitted: json['hasSubmitted'] as bool? ?? false,
  attemptStatus: json['attemptStatus'] as String?,
  attempts:
      (json['attempts'] as List<dynamic>?)
          ?.map((e) => AttemptSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$StudentExamWithAttemptsModelToJson(
  StudentExamWithAttemptsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'classroomId': instance.classroomId,
  'classroomName': instance.classroomName,
  'latestScore': instance.latestScore,
  'usedAttempts': instance.usedAttempts,
  'allowedAttempts': instance.allowedAttempts,
  'hasSubmitted': instance.hasSubmitted,
  'attemptStatus': instance.attemptStatus,
  'attempts': instance.attempts,
};

StudentExamsHistoryPagedResultModel
_$StudentExamsHistoryPagedResultModelFromJson(Map<String, dynamic> json) =>
    StudentExamsHistoryPagedResultModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => StudentExamWithAttemptsModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StudentExamsHistoryPagedResultModelToJson(
  StudentExamsHistoryPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
};
