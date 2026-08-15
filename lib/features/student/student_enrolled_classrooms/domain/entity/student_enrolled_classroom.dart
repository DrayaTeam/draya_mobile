class StudentEnrolledClassroom {
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

  const StudentEnrolledClassroom({
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
}
