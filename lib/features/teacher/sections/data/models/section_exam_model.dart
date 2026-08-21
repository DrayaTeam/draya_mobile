import "package:json_annotation/json_annotation.dart";

part "section_exam_model.g.dart";

@JsonSerializable()
class SectionExamModel {
  final String id;
  final String topic;
  final int questionsCount;
  final DateTime createdAt;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;

  const SectionExamModel({
    required this.id,
    required this.topic,
    required this.questionsCount,
    required this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
  });

  factory SectionExamModel.fromJson(Map<String, dynamic> json) =>
      _$SectionExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionExamModelToJson(this);
}
