// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_roster_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentRosterPagedResultModel _$StudentRosterPagedResultModelFromJson(
  Map<String, dynamic> json,
) => StudentRosterPagedResultModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => StudentRosterItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$StudentRosterPagedResultModelToJson(
  StudentRosterPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
};
