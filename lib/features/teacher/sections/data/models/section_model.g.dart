// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionModel _$SectionModelFromJson(Map<String, dynamic> json) => SectionModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  order: (json['order'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  documents: (json['documents'] as List<dynamic>)
      .map((e) => SectionDocumentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  videos: (json['videos'] as List<dynamic>)
      .map((e) => SectionVideoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  exams: (json['exams'] as List<dynamic>)
      .map((e) => SectionExamModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SectionModelToJson(SectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'createdAt': instance.createdAt.toIso8601String(),
      'documents': instance.documents,
      'videos': instance.videos,
      'exams': instance.exams,
    };
