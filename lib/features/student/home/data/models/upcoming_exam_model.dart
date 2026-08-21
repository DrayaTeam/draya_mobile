import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:json_annotation/json_annotation.dart";

part "upcoming_exam_model.g.dart";

@JsonSerializable()
class UpcomingExamModel {
  @JsonKey(defaultValue: "")
  final String examId;
  @JsonKey(defaultValue: "")
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  const UpcomingExamModel({
    required this.examId,
    required this.title,
    this.startDate,
    this.endDate,
  });

  factory UpcomingExamModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpcomingExamModelToJson(this);

  UpcomingExam toEntity() => UpcomingExam(
        examId: examId,
        title: title,
        startDate: startDate,
        endDate: endDate,
      );
}
