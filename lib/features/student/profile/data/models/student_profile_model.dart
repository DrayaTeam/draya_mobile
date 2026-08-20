import "package:json_annotation/json_annotation.dart";

part "student_profile_model.g.dart";

@JsonSerializable(includeIfNull: false)
class StudentProfileModel {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? parentGuardianEmail;
  final DateTime? dateOfBirth;
  final String? profilePictureUrl;

  const StudentProfileModel({
    this.userId,
    this.email,
    this.fullName,
    this.parentGuardianEmail,
    this.dateOfBirth,
    this.profilePictureUrl,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentProfileModelToJson(this);
}
