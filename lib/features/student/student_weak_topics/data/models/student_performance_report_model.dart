import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";
import "package:json_annotation/json_annotation.dart";

part "student_performance_report_model.g.dart";

@JsonSerializable()
class WeakTopicModel {
  @JsonKey(name: "topicName", defaultValue: "")
  final String topicName;

  @JsonKey(name: "proficiencyPercent", defaultValue: 0.0)
  final double proficiencyPercent;

  @JsonKey(name: "recommendation", defaultValue: "")
  final String recommendation;

  const WeakTopicModel({
    required this.topicName,
    required this.proficiencyPercent,
    required this.recommendation,
  });

  factory WeakTopicModel.fromJson(Map<String, dynamic> json) =>
      _$WeakTopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeakTopicModelToJson(this);

  WeakTopic toEntity() {
    return WeakTopic(
      topicName: topicName,
      proficiencyPercent: proficiencyPercent,
      recommendation: recommendation,
    );
  }
}

@JsonSerializable()
class SubjectProficiencyModel {
  @JsonKey(name: "subjectName", defaultValue: "")
  final String subjectName;

  @JsonKey(name: "proficiencyPercent", defaultValue: 0.0)
  final double proficiencyPercent;

  const SubjectProficiencyModel({
    required this.subjectName,
    required this.proficiencyPercent,
  });

  factory SubjectProficiencyModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectProficiencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectProficiencyModelToJson(this);

  SubjectProficiency toEntity() {
    return SubjectProficiency(
      subjectName: subjectName,
      proficiencyPercent: proficiencyPercent,
    );
  }
}

@JsonSerializable()
class StudentPerformanceReportModel {
  @JsonKey(name: "id", defaultValue: "")
  final String id;

  @JsonKey(name: "generatedAt")
  final DateTime? generatedAt;

  @JsonKey(name: "summaryText", defaultValue: "")
  final String summaryText;

  @JsonKey(name: "weakTopics", defaultValue: [])
  final List<WeakTopicModel> weakTopics;

  @JsonKey(name: "subjectProficiencies", defaultValue: [])
  final List<SubjectProficiencyModel> subjectProficiencies;

  const StudentPerformanceReportModel({
    required this.id,
    this.generatedAt,
    required this.summaryText,
    required this.weakTopics,
    required this.subjectProficiencies,
  });

  factory StudentPerformanceReportModel.fromJson(Map<String, dynamic> json) =>
      _$StudentPerformanceReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentPerformanceReportModelToJson(this);

  StudentPerformanceReport toEntity() {
    return StudentPerformanceReport(
      id: id,
      generatedAt: generatedAt ?? DateTime.now(),
      summaryText: summaryText,
      weakTopics: weakTopics.map((w) => w.toEntity()).toList(),
      subjectProficiencies:
          subjectProficiencies.map((s) => s.toEntity()).toList(),
    );
  }
}
