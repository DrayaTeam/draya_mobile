import "package:json_annotation/json_annotation.dart";

part "section_exam_model.g.dart";

@JsonSerializable()
class SectionExamModel {
  final String id;
  final String topic;
  final int questionsCount;
  final DateTime createdAt;

  const SectionExamModel({
    required this.id,
    required this.topic,
    required this.questionsCount,
    required this.createdAt,
  });

  factory SectionExamModel.fromJson(Map<String, dynamic> json) =>
      _$SectionExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionExamModelToJson(this);
}
