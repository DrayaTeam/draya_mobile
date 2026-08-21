// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcomingExamModel _$UpcomingExamModelFromJson(Map<String, dynamic> json) =>
    UpcomingExamModel(
      examId: json['examId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$UpcomingExamModelToJson(UpcomingExamModel instance) =>
    <String, dynamic>{
      'examId': instance.examId,
      'title': instance.title,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
