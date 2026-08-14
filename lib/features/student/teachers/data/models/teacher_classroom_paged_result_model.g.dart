// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_classroom_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherClassroomPagedResultModel _$TeacherClassroomPagedResultModelFromJson(
  Map<String, dynamic> json,
) => TeacherClassroomPagedResultModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => TeacherClassroomModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$TeacherClassroomPagedResultModelToJson(
  TeacherClassroomPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
};
