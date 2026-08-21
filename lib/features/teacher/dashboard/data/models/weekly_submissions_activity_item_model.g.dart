// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_submissions_activity_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklySubmissionsActivityItemModel _$WeeklySubmissionsActivityItemModelFromJson(
  Map<String, dynamic> json,
) => WeeklySubmissionsActivityItemModel(
  dayOfWeek: json['dayOfWeek'] as String,
  submissionsCount: (json['submissionsCount'] as num).toInt(),
  averageScore: (json['averageScore'] as num).toDouble(),
);

Map<String, dynamic> _$WeeklySubmissionsActivityItemModelToJson(
  WeeklySubmissionsActivityItemModel instance,
) => <String, dynamic>{
  'dayOfWeek': instance.dayOfWeek,
  'submissionsCount': instance.submissionsCount,
  'averageScore': instance.averageScore,
};
