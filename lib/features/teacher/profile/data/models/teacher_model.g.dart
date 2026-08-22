// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
  userId: json['userId'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String,
  specialization: json['specialization'] as String?,
  description: json['description'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  classroomsCount: (json['classroomsCount'] as num).toInt(),
  studentsCount: (json['studentsCount'] as num).toInt(),
  lessonsCount: (json['lessonsCount'] as num).toInt(),
  averageRating: (json['averageRating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'specialization': instance.specialization,
      'description': instance.description,
      'profilePictureUrl': instance.profilePictureUrl,
      'classroomsCount': instance.classroomsCount,
      'studentsCount': instance.studentsCount,
      'lessonsCount': instance.lessonsCount,
      'averageRating': instance.averageRating,
    };
