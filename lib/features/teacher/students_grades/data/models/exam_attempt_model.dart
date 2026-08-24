import "package:json_annotation/json_annotation.dart";

part "exam_attempt_model.g.dart";

@JsonSerializable()
class ExamAttemptModel {
  final String id;
  final String studentId;
  final String studentName;
  final double finalScore;
  final double? maxScore;
  final DateTime? submittedAt;
  @JsonKey(name: "needsTeacherReview", defaultValue: false)
  final bool needsTeacherReview;

  const ExamAttemptModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.finalScore,
    this.maxScore,
    this.submittedAt,
    this.needsTeacherReview = false,
  });

  factory ExamAttemptModel.fromJson(Map<String, dynamic> json) =>
      _$ExamAttemptModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamAttemptModelToJson(this);

  bool get hasMaxScore => maxScore != null && maxScore! > 0;

  double get scorePercent => hasMaxScore
      ? ((finalScore / maxScore!) * 100).clamp(0.0, 100.0)
      : finalScore.clamp(0.0, 100.0);
}
