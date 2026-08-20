import "package:json_annotation/json_annotation.dart";

part "section_document_model.g.dart";

@JsonSerializable()
class SectionDocumentModel {
  final String id;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final String? fileUrl;

  const SectionDocumentModel({
    required this.id,
    required this.title,
    required this.materialType,
    required this.createdAt,
    required this.fileUrl,
  });

  factory SectionDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$SectionDocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionDocumentModelToJson(this);
}
