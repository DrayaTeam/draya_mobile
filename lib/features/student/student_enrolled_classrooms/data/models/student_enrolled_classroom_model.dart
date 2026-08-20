import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";
import "package:json_annotation/json_annotation.dart";

part "student_enrolled_classroom_model.g.dart";

@JsonSerializable()
class StudentEnrolledClassroomModel {
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

  const StudentEnrolledClassroomModel({
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

  factory StudentEnrolledClassroomModel.fromJson(Map<String, dynamic> json) =>
      _$StudentEnrolledClassroomModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentEnrolledClassroomModelToJson(this);
}

extension StudentEnrolledClassroomModelMapper on StudentEnrolledClassroomModel {
  StudentEnrolledClassroom toEntity() => StudentEnrolledClassroom(
    classroomId: classroomId,
    teacherId: teacherId,
    subjectName: subjectName,
    name: name,
    enrollmentCode: enrollmentCode,
    isActive: isActive,
    studentCount: studentCount,
    createdAt: createdAt,
    classroomTypeName: classroomTypeName,
    gradeLevelName: gradeLevelName,
    startDate: startDate,
    endDate: endDate,
    price: price,
  );
}
