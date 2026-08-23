// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_attempt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamAttemptModel _$ExamAttemptModelFromJson(Map<String, dynamic> json) =>
    ExamAttemptModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      finalScore: (json['finalScore'] as num).toDouble(),
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      needsTeacherReview: json['needsTeacherReview'] as bool? ?? false,
    );

Map<String, dynamic> _$ExamAttemptModelToJson(ExamAttemptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'finalScore': instance.finalScore,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'needsTeacherReview': instance.needsTeacherReview,
    };
