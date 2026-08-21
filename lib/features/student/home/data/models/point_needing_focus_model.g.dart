// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_needing_focus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointNeedingFocusModel _$PointNeedingFocusModelFromJson(
  Map<String, dynamic> json,
) => PointNeedingFocusModel(
  topicName: json['topicName'] as String? ?? '',
  proficiencyPercent: (json['proficiencyPercent'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$PointNeedingFocusModelToJson(
  PointNeedingFocusModel instance,
) => <String, dynamic>{
  'topicName': instance.topicName,
  'proficiencyPercent': instance.proficiencyPercent,
};
