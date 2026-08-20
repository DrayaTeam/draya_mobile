import "package:json_annotation/json_annotation.dart";

import "package:draya_mobile/features/student/profile/data/models/student_profile_model.dart";

part "user_profile_model.g.dart";

@JsonSerializable(includeIfNull: false)
class UserProfileModel {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? role;
  final String? parentGuardianEmail;
  final DateTime? dateOfBirth;
  final String? profilePictureUrl;

  const UserProfileModel({
    this.userId,
    this.email,
    this.fullName,
    this.role,
    this.parentGuardianEmail,
    this.dateOfBirth,
    this.profilePictureUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}

extension UserProfileModelX on UserProfileModel {
  StudentProfileModel toStudentProfileModel() {
    return StudentProfileModel(
      userId: userId,
      email: email,
      fullName: fullName ?? "",
      parentGuardianEmail: parentGuardianEmail ?? "",
      dateOfBirth: dateOfBirth,
      profilePictureUrl: profilePictureUrl,
    );
  }
}
