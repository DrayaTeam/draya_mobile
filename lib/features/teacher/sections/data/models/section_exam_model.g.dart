// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionExamModel _$SectionExamModelFromJson(Map<String, dynamic> json) =>
    SectionExamModel(
      id: json['id'] as String,
      topic: json['topic'] as String,
      questionsCount: (json['questionsCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SectionExamModelToJson(SectionExamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'questionsCount': instance.questionsCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
