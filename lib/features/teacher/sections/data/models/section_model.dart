import "package:draya_mobile/features/teacher/sections/data/models/section_document_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_exam_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_video_model.dart";
import "package:json_annotation/json_annotation.dart";

part "section_model.g.dart";

@JsonSerializable()
class SectionModel {
  final String id;
  final String title;
  final String description;
  final int order;
  final DateTime createdAt;
  final List<SectionDocumentModel> documents;
  final List<SectionVideoModel> videos;
  final List<SectionExamModel> exams;

  const SectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.createdAt,
    required this.documents,
    required this.videos,
    required this.exams,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) =>
      _$SectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionModelToJson(this);
}
