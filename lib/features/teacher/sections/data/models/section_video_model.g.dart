// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionVideoModel _$SectionVideoModelFromJson(Map<String, dynamic> json) =>
    SectionVideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      materialType: json['materialType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      videoUrl: json['videoUrl'] as String?,
      videoDurationInSeconds: (json['videoDurationInSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$SectionVideoModelToJson(SectionVideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'materialType': instance.materialType,
      'createdAt': instance.createdAt.toIso8601String(),
      'videoUrl': instance.videoUrl,
      'videoDurationInSeconds': instance.videoDurationInSeconds,
    };
