// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_performance_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeakTopicModel _$WeakTopicModelFromJson(Map<String, dynamic> json) =>
    WeakTopicModel(
      topicName: json['topicName'] as String? ?? '',
      proficiencyPercent:
          (json['proficiencyPercent'] as num?)?.toDouble() ?? 0.0,
      recommendation: json['recommendation'] as String? ?? '',
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$WeakTopicModelToJson(WeakTopicModel instance) =>
    <String, dynamic>{
      'topicName': instance.topicName,
      'proficiencyPercent': instance.proficiencyPercent,
      'recommendation': instance.recommendation,
      'isActive': instance.isActive,
    };

SubjectProficiencyModel _$SubjectProficiencyModelFromJson(
  Map<String, dynamic> json,
) => SubjectProficiencyModel(
  subjectName: json['subjectName'] as String? ?? '',
  proficiencyPercent: (json['proficiencyPercent'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$SubjectProficiencyModelToJson(
  SubjectProficiencyModel instance,
) => <String, dynamic>{
  'subjectName': instance.subjectName,
  'proficiencyPercent': instance.proficiencyPercent,
};

StudentPerformanceReportModel _$StudentPerformanceReportModelFromJson(
  Map<String, dynamic> json,
) => StudentPerformanceReportModel(
  id: json['id'] as String? ?? '',
  generatedAt: json['generatedAt'] == null
      ? null
      : DateTime.parse(json['generatedAt'] as String),
  summaryText: json['summaryText'] as String? ?? '',
  weakTopics:
      (json['weakTopics'] as List<dynamic>?)
          ?.map((e) => WeakTopicModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  subjectProficiencies:
      (json['subjectProficiencies'] as List<dynamic>?)
          ?.map(
            (e) => SubjectProficiencyModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$StudentPerformanceReportModelToJson(
  StudentPerformanceReportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'generatedAt': instance.generatedAt?.toIso8601String(),
  'summaryText': instance.summaryText,
  'weakTopics': instance.weakTopics,
  'subjectProficiencies': instance.subjectProficiencies,
};
