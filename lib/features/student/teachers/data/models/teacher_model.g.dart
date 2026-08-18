// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
  userId: json['userId'] as String?,
  email: json['email'] as String?,
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  specialization: json['specialization'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
);

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'specialization': instance.specialization,
      'profilePictureUrl': instance.profilePictureUrl,
    };
