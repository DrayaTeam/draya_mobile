import "package:json_annotation/json_annotation.dart";

part "teacher_model.g.dart";

@JsonSerializable()
class TeacherModel {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? specialization;
  final String? profilePictureUrl;

  const TeacherModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.specialization,
    this.profilePictureUrl,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);
}
