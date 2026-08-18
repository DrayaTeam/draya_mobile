// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_material_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherMaterialPagedResultModel _$TeacherMaterialPagedResultModelFromJson(
  Map<String, dynamic> json,
) => TeacherMaterialPagedResultModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => TeacherMaterialModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$TeacherMaterialPagedResultModelToJson(
  TeacherMaterialPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
};
