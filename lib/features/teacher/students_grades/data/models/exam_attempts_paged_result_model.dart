import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempt_model.dart";
import "package:json_annotation/json_annotation.dart";

part "exam_attempts_paged_result_model.g.dart";

@JsonSerializable()
class ExamAttemptsPagedResultModel {
  final List<ExamAttemptModel> items;
  final int totalCount;

  const ExamAttemptsPagedResultModel({
    required this.items,
    required this.totalCount,
  });

  factory ExamAttemptsPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$ExamAttemptsPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ExamAttemptsPagedResultModelToJson(this);
}
