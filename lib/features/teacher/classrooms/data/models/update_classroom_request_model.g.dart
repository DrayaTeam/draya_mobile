// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_classroom_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateClassroomRequestModel _$UpdateClassroomRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateClassroomRequestModel(
  subjectId: json['subjectId'] as String,
  name: json['name'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$UpdateClassroomRequestModelToJson(
  UpdateClassroomRequestModel instance,
) => <String, dynamic>{
  'subjectId': instance.subjectId,
  'name': instance.name,
  'isActive': instance.isActive,
};
