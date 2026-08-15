// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_enrolled_classroom_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentEnrolledClassroomPagedResultModel
_$StudentEnrolledClassroomPagedResultModelFromJson(Map<String, dynamic> json) =>
    StudentEnrolledClassroomPagedResultModel(
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => StudentEnrolledClassroomModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$StudentEnrolledClassroomPagedResultModelToJson(
  StudentEnrolledClassroomPagedResultModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
};
