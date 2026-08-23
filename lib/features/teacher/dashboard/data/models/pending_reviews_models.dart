import "package:json_annotation/json_annotation.dart";

part "pending_reviews_models.g.dart";

@JsonSerializable()
class PendingReviewAttemptModel {
  final String attemptId;
  final String studentId;
  final String studentName;
  final DateTime? submittedAt;
  final double score;

  const PendingReviewAttemptModel({
    required this.attemptId,
    required this.studentId,
    required this.studentName,
    this.submittedAt,
    this.score = 0.0,
  });

  factory PendingReviewAttemptModel.fromJson(Map<String, dynamic> json) =>
      _$PendingReviewAttemptModelFromJson(json);

  Map<String, dynamic> toJson() => _$PendingReviewAttemptModelToJson(this);
}

@JsonSerializable()
class ExamPendingReviewsModel {
  final String examId;
  final String examTitle;
  @JsonKey(defaultValue: [])
  final List<PendingReviewAttemptModel> pendingReviews;

  const ExamPendingReviewsModel({
    required this.examId,
    required this.examTitle,
    this.pendingReviews = const [],
  });

  factory ExamPendingReviewsModel.fromJson(Map<String, dynamic> json) =>
      _$ExamPendingReviewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamPendingReviewsModelToJson(this);
}

@JsonSerializable()
class ClassroomPendingReviewsModel {
  final String classroomId;
  final String classroomName;
  @JsonKey(defaultValue: [])
  final List<ExamPendingReviewsModel> exams;

  const ClassroomPendingReviewsModel({
    required this.classroomId,
    required this.classroomName,
    this.exams = const [],
  });

  factory ClassroomPendingReviewsModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomPendingReviewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomPendingReviewsModelToJson(this);
}
