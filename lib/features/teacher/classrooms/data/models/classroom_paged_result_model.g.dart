// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomPagedResultModel _$ClassroomPagedResultModelFromJson(
  Map<String, dynamic> json,
) => ClassroomPagedResultModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => ClassroomModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$ClassroomPagedResultModelToJson(
  ClassroomPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
};
