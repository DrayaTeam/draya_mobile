import "package:json_annotation/json_annotation.dart";

part "exam_attempt_model.g.dart";

@JsonSerializable()
class ExamAttemptModel {
  final String id;
  final String studentId;
  final String studentName;
  final double finalScore;
  final DateTime? submittedAt;

  const ExamAttemptModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.finalScore,
    this.submittedAt,
  });

  factory ExamAttemptModel.fromJson(Map<String, dynamic> json) =>
      _$ExamAttemptModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamAttemptModelToJson(this);
}
