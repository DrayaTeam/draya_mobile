// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_attempts_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamAttemptsPagedResultModel _$ExamAttemptsPagedResultModelFromJson(
  Map<String, dynamic> json,
) => ExamAttemptsPagedResultModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => ExamAttemptModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
);

Map<String, dynamic> _$ExamAttemptsPagedResultModelToJson(
  ExamAttemptsPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'totalCount': instance.totalCount,
};
