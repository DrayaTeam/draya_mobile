// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_teacher_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterTeacherRequestModel _$RegisterTeacherRequestModelFromJson(
  Map<String, dynamic> json,
) => RegisterTeacherRequestModel(
  email: json['email'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirmPassword'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String?,
  specialization: json['specialization'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$RegisterTeacherRequestModelToJson(
  RegisterTeacherRequestModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'confirmPassword': instance.confirmPassword,
  'fullName': instance.fullName,
  'phone': ?instance.phone,
  'specialization': ?instance.specialization,
  'description': ?instance.description,
};
