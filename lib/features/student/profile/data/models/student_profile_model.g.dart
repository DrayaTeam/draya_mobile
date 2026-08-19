// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProfileModel _$StudentProfileModelFromJson(Map<String, dynamic> json) =>
    StudentProfileModel(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      parentGuardianEmail: json['parentGuardianEmail'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );

Map<String, dynamic> _$StudentProfileModelToJson(
  StudentProfileModel instance,
) => <String, dynamic>{
  'userId': ?instance.userId,
  'email': ?instance.email,
  'fullName': ?instance.fullName,
  'parentGuardianEmail': ?instance.parentGuardianEmail,
  'dateOfBirth': ?instance.dateOfBirth?.toIso8601String(),
  'profilePictureUrl': ?instance.profilePictureUrl,
};
