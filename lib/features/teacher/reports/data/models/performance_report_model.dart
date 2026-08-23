import "package:draya_mobile/features/teacher/reports/data/models/subject_proficiencies_model.dart";
import "package:draya_mobile/features/teacher/reports/data/models/weak_topics_model.dart";
import "package:json_annotation/json_annotation.dart";

part "performance_report_model.g.dart";

@JsonSerializable()
class PerformanceReportModel {
  final String id;
  final DateTime generatedAt;
  final String summaryText;
  final List<WeakTopicsModel> weakTopics;
  final List<SubjectProficienciesModel> subjectProficiencies;
  final int totalQuestionsAsked;
  final int totalQuestionsReplied;
  final double averageExamDurationMinutes;
  final int completedLessons;
  final double classroomPercentile;

  PerformanceReportModel({
    required this.id,
    required this.generatedAt,
    required this.summaryText,
    required this.weakTopics,
    required this.subjectProficiencies,
    required this.totalQuestionsAsked,
    required this.totalQuestionsReplied,
    required this.averageExamDurationMinutes,
    required this.completedLessons,
    required this.classroomPercentile,
  });

  factory PerformanceReportModel.fromJson(Map<String, dynamic> json) =>
      _$PerformanceReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceReportModelToJson(this);
}
