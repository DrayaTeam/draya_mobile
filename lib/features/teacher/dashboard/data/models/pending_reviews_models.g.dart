// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_reviews_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingReviewAttemptModel _$PendingReviewAttemptModelFromJson(
  Map<String, dynamic> json,
) => PendingReviewAttemptModel(
  attemptId: json['attemptId'] as String,
  studentId: json['studentId'] as String,
  studentName: json['studentName'] as String,
  submittedAt: json['submittedAt'] == null
      ? null
      : DateTime.parse(json['submittedAt'] as String),
  score: (json['score'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$PendingReviewAttemptModelToJson(
  PendingReviewAttemptModel instance,
) => <String, dynamic>{
  'attemptId': instance.attemptId,
  'studentId': instance.studentId,
  'studentName': instance.studentName,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'score': instance.score,
};

ExamPendingReviewsModel _$ExamPendingReviewsModelFromJson(
  Map<String, dynamic> json,
) => ExamPendingReviewsModel(
  examId: json['examId'] as String,
  examTitle: json['examTitle'] as String,
  pendingReviews:
      (json['pendingReviews'] as List<dynamic>?)
          ?.map(
            (e) =>
                PendingReviewAttemptModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$ExamPendingReviewsModelToJson(
  ExamPendingReviewsModel instance,
) => <String, dynamic>{
  'examId': instance.examId,
  'examTitle': instance.examTitle,
  'pendingReviews': instance.pendingReviews,
};

ClassroomPendingReviewsModel _$ClassroomPendingReviewsModelFromJson(
  Map<String, dynamic> json,
) => ClassroomPendingReviewsModel(
  classroomId: json['classroomId'] as String,
  classroomName: json['classroomName'] as String,
  exams:
      (json['exams'] as List<dynamic>?)
          ?.map(
            (e) => ExamPendingReviewsModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$ClassroomPendingReviewsModelToJson(
  ClassroomPendingReviewsModel instance,
) => <String, dynamic>{
  'classroomId': instance.classroomId,
  'classroomName': instance.classroomName,
  'exams': instance.exams,
};
