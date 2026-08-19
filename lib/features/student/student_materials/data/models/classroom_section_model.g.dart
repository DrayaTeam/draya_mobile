// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionDocumentModel _$SectionDocumentModelFromJson(
  Map<String, dynamic> json,
) =>
    SectionDocumentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      materialType: json['materialType'] as String? ?? 'Document',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String),
      fileUrl: json['fileUrl'] as String?,
    );

Map<String, dynamic> _$SectionDocumentModelToJson(
  SectionDocumentModel instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'materialType': instance.materialType,
      'createdAt': instance.createdAt.toIso8601String(),
      'fileUrl': instance.fileUrl,
    };

SectionVideoModel _$SectionVideoModelFromJson(
  Map<String, dynamic> json,
) =>
    SectionVideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      materialType: json['materialType'] as String? ?? 'Video',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String),
      videoUrl: json['videoUrl'] as String?,
      videoDurationInSeconds: (json['videoDurationInSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SectionVideoModelToJson(
  SectionVideoModel instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'materialType': instance.materialType,
      'createdAt': instance.createdAt.toIso8601String(),
      'videoUrl': instance.videoUrl,
      'videoDurationInSeconds': instance.videoDurationInSeconds,
    };

SectionExamModel _$SectionExamModelFromJson(
  Map<String, dynamic> json,
) =>
    SectionExamModel(
      id: json['id'] as String,
      topic: json['topic'] as String? ?? '',
      questionsCount: (json['questionsCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SectionExamModelToJson(
  SectionExamModel instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'questionsCount': instance.questionsCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

ClassroomSectionModel _$ClassroomSectionModelFromJson(
  Map<String, dynamic> json,
) =>
    ClassroomSectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String),
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) =>
                  SectionDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => SectionVideoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exams: (json['exams'] as List<dynamic>?)
              ?.map((e) => SectionExamModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ClassroomSectionModelToJson(
  ClassroomSectionModel instance,
) =>
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
