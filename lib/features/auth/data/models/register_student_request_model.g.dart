// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_student_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterStudentRequestModel _$RegisterStudentRequestModelFromJson(
  Map<String, dynamic> json,
) => RegisterStudentRequestModel(
  email: json['email'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirmPassword'] as String,
  fullName: json['fullName'] as String,
  parentGuardianName: json['parentGuardianName'] as String,
  parentGuardianPhone: json['parentGuardianPhone'] as String,
  parentGuardianEmail: json['parentGuardianEmail'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
);

Map<String, dynamic> _$RegisterStudentRequestModelToJson(
  RegisterStudentRequestModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'confirmPassword': instance.confirmPassword,
  'fullName': instance.fullName,
  'parentGuardianName': instance.parentGuardianName,
  'parentGuardianPhone': instance.parentGuardianPhone,
  'parentGuardianEmail': instance.parentGuardianEmail,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
};
