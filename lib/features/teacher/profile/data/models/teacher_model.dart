import "package:json_annotation/json_annotation.dart";

part "teacher_model.g.dart";

@JsonSerializable()
class TeacherModel {
  final String userId;
  final String email;
  final String fullName;
  final String phone;
  final String? specialization;
  final String? description;
  final String? profilePictureUrl;
  final int classroomsCount;
  final int studentsCount;
  final int lessonsCount;
  final double? averageRating;

  const TeacherModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phone,
    this.specialization,
    this.description,
    this.profilePictureUrl,
    required this.classroomsCount,
    required this.studentsCount,
    required this.lessonsCount,
    this.averageRating,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);
}
