// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_teacher_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTeacherRequestModel _$UpdateTeacherRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateTeacherRequestModel(
  fullName: json['fullName'] as String,
  phone: json['phone'] as String,
  specialization: json['specialization'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$UpdateTeacherRequestModelToJson(
  UpdateTeacherRequestModel instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'phone': instance.phone,
  'specialization': instance.specialization,
  'description': instance.description,
};
