// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionPagedResultModel _$QuestionPagedResultModelFromJson(
  Map<String, dynamic> json,
) => QuestionPagedResultModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$QuestionPagedResultModelToJson(
  QuestionPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'pageNumber': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
};
