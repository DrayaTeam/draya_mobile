import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:json_annotation/json_annotation.dart";

part "daily_lesson_model.g.dart";

@JsonSerializable()
class DailyLessonModel {
  @JsonKey(defaultValue: "")
  final String materialId;
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: 0)
  final int completedLectures;
  @JsonKey(defaultValue: 0)
  final int totalLectures;

  const DailyLessonModel({
    required this.materialId,
    required this.title,
    required this.completedLectures,
    required this.totalLectures,
  });

  factory DailyLessonModel.fromJson(Map<String, dynamic> json) =>
      _$DailyLessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyLessonModelToJson(this);

  DailyLesson toEntity() => DailyLesson(
        materialId: materialId,
        title: title,
        completedLectures: completedLectures,
        totalLectures: totalLectures,
      );
}
