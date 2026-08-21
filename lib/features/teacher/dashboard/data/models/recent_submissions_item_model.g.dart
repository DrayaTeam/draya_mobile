// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_submissions_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentSubmissionsItemModel _$RecentSubmissionsItemModelFromJson(
  Map<String, dynamic> json,
) => RecentSubmissionsItemModel(
  examAttemptId: json['examAttemptId'] as String,
  studentId: json['studentId'] as String,
  studentName: json['studentName'] as String,
  examTitle: json['examTitle'] as String,
  submittedAt: json['submittedAt'] as String,
  score: (json['score'] as num).toDouble(),
);

Map<String, dynamic> _$RecentSubmissionsItemModelToJson(
  RecentSubmissionsItemModel instance,
) => <String, dynamic>{
  'examAttemptId': instance.examAttemptId,
  'studentId': instance.studentId,
  'studentName': instance.studentName,
  'examTitle': instance.examTitle,
  'submittedAt': instance.submittedAt,
  'score': instance.score,
};
