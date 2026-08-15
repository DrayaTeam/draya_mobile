// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      role: json['role'] as String?,
      parentGuardianEmail: json['parentGuardianEmail'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'userId': ?instance.userId,
      'email': ?instance.email,
      'fullName': ?instance.fullName,
      'role': ?instance.role,
      'parentGuardianEmail': ?instance.parentGuardianEmail,
      'dateOfBirth': ?instance.dateOfBirth?.toIso8601String(),
    };
