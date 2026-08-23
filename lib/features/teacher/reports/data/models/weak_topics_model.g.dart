// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weak_topics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeakTopicsModel _$WeakTopicsModelFromJson(Map<String, dynamic> json) =>
    WeakTopicsModel(
      topicName: json['topicName'] as String,
      proficiencyPercent: (json['proficiencyPercent'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
    );

Map<String, dynamic> _$WeakTopicsModelToJson(WeakTopicsModel instance) =>
    <String, dynamic>{
      'topicName': instance.topicName,
      'proficiencyPercent': instance.proficiencyPercent,
      'recommendation': instance.recommendation,
    };
