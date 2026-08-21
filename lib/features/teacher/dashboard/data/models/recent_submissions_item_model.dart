import "package:json_annotation/json_annotation.dart";

part "recent_submissions_item_model.g.dart";

@JsonSerializable()
class RecentSubmissionsItemModel {
  final String examAttemptId;
  final String studentId;
  final String studentName;
  final String examTitle;
  final String submittedAt;
  final double score;

  const RecentSubmissionsItemModel({
    required this.examAttemptId,
    required this.studentId,
    required this.studentName,
    required this.examTitle,
    required this.submittedAt,
    required this.score,
  });

  factory RecentSubmissionsItemModel.fromJson(Map<String, dynamic> json) =>
      _$RecentSubmissionsItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentSubmissionsItemModelToJson(this);
}
