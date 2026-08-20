import "package:json_annotation/json_annotation.dart";

part "teacher_classroom_model.g.dart";

@JsonSerializable()
class TeacherClassroomModel {
  final String classroomId;
  final String teacherId;
  final String subjectName;
  final String name;
  final String enrollmentCode;
  final bool isActive;
  final int studentCount;
  final DateTime createdAt;
  final String classroomTypeName;
  final String gradeLevelName;
  final DateTime? startDate;
  final DateTime? endDate;
  final double price;

  const TeacherClassroomModel({
    required this.classroomId,
    required this.teacherId,
    required this.subjectName,
    required this.name,
    required this.enrollmentCode,
    required this.isActive,
    required this.studentCount,
    required this.createdAt,
    required this.classroomTypeName,
    required this.gradeLevelName,
    this.startDate,
    this.endDate,
    required this.price,
  });

  factory TeacherClassroomModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherClassroomModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherClassroomModelToJson(this);
}
