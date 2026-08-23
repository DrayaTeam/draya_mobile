// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceReportModel _$PerformanceReportModelFromJson(
  Map<String, dynamic> json,
) => PerformanceReportModel(
  id: json['id'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  summaryText: json['summaryText'] as String,
  weakTopics: (json['weakTopics'] as List<dynamic>)
      .map((e) => WeakTopicsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  subjectProficiencies: (json['subjectProficiencies'] as List<dynamic>)
      .map((e) => SubjectProficienciesModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalQuestionsAsked: (json['totalQuestionsAsked'] as num).toInt(),
  totalQuestionsReplied: (json['totalQuestionsReplied'] as num).toInt(),
  averageExamDurationMinutes: (json['averageExamDurationMinutes'] as num)
      .toDouble(),
  completedLessons: (json['completedLessons'] as num).toInt(),
  classroomPercentile: (json['classroomPercentile'] as num).toDouble(),
);

Map<String, dynamic> _$PerformanceReportModelToJson(
  PerformanceReportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'summaryText': instance.summaryText,
  'weakTopics': instance.weakTopics,
  'subjectProficiencies': instance.subjectProficiencies,
  'totalQuestionsAsked': instance.totalQuestionsAsked,
  'totalQuestionsReplied': instance.totalQuestionsReplied,
  'averageExamDurationMinutes': instance.averageExamDurationMinutes,
  'completedLessons': instance.completedLessons,
  'classroomPercentile': instance.classroomPercentile,
};
