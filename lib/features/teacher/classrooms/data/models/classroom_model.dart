import "package:draya_mobile/features/teacher/classrooms/domain/entity/classroom.dart";
import "package:json_annotation/json_annotation.dart";

part "classroom_model.g.dart";

@JsonSerializable()
class ClassroomModel {
  final String classroomId;
  final String teacherId;
  final String subjectName;
  final String name;
  final String enrollmentCode;
  final bool isActive;
  final int studentCount;
  final DateTime createdAt;

  const ClassroomModel({
    required this.classroomId,
    required this.teacherId,
    required this.subjectName,
    required this.name,
    required this.enrollmentCode,
    required this.isActive,
    required this.studentCount,
    required this.createdAt,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomModelToJson(this);
}

extension ClassroomModelExtension on ClassroomModel {
  Classroom toEntity() => Classroom(
    classroomId: classroomId,
    teacherId: teacherId,
    subjectName: subjectName,
    name: name,
    enrollmentCode: enrollmentCode,
    isActive: isActive,
    studentCount: studentCount,
    createdAt: createdAt,
  );
}
