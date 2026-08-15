// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_student_profile_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStudentProfileRequestModel _$UpdateStudentProfileRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateStudentProfileRequestModel(
  fullName: json['fullName'] as String,
  parentGuardianEmail: json['parentGuardianEmail'] as String,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
);

Map<String, dynamic> _$UpdateStudentProfileRequestModelToJson(
  UpdateStudentProfileRequestModel instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'parentGuardianEmail': instance.parentGuardianEmail,
  'dateOfBirth': ?instance.dateOfBirth?.toIso8601String(),
};
