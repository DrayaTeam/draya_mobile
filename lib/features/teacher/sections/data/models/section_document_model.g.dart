// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionDocumentModel _$SectionDocumentModelFromJson(
  Map<String, dynamic> json,
) => SectionDocumentModel(
  id: json['id'] as String,
  title: json['title'] as String,
  materialType: json['materialType'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  fileUrl: json['fileUrl'] as String?,
);

Map<String, dynamic> _$SectionDocumentModelToJson(
  SectionDocumentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'materialType': instance.materialType,
  'createdAt': instance.createdAt.toIso8601String(),
  'fileUrl': instance.fileUrl,
};
