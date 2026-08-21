import "package:json_annotation/json_annotation.dart";

part "weekly_submissions_activity_item_model.g.dart";

@JsonSerializable()
class WeeklySubmissionsActivityItemModel {
  final String dayOfWeek;
  final int submissionsCount;
  final double averageScore;

  const WeeklySubmissionsActivityItemModel({
    required this.dayOfWeek,
    required this.submissionsCount,
    required this.averageScore,
  });

  factory WeeklySubmissionsActivityItemModel.fromJson(
    Map<String, dynamic> json,
  ) => _$WeeklySubmissionsActivityItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$WeeklySubmissionsActivityItemModelToJson(this);
}
