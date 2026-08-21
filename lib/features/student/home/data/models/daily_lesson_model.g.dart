// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyLessonModel _$DailyLessonModelFromJson(Map<String, dynamic> json) =>
    DailyLessonModel(
      materialId: json['materialId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      completedLectures: (json['completedLectures'] as num?)?.toInt() ?? 0,
      totalLectures: (json['totalLectures'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DailyLessonModelToJson(DailyLessonModel instance) =>
    <String, dynamic>{
      'materialId': instance.materialId,
      'title': instance.title,
      'completedLectures': instance.completedLectures,
      'totalLectures': instance.totalLectures,
    };
