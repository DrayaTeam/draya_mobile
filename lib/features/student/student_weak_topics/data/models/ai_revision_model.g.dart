// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_revision_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiRevisionModel _$AiRevisionModelFromJson(Map<String, dynamic> json) =>
    AiRevisionModel(
      recommendation: json['recommendation'] as String? ?? '',
      aiExplanation: json['aiExplanation'] as String? ?? '',
    );

Map<String, dynamic> _$AiRevisionModelToJson(AiRevisionModel instance) =>
    <String, dynamic>{
      'recommendation': instance.recommendation,
      'aiExplanation': instance.aiExplanation,
    };
