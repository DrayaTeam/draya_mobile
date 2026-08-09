class Classroom {
  final String classroomId;
  final String teacherId;
  final String subjectName;
  final String name;
  final String enrollmentCode;
  final bool isActive;
  final int studentCount;
  final DateTime createdAt;

  const Classroom({
    required this.classroomId,
    required this.teacherId,
    required this.subjectName,
    required this.name,
    required this.enrollmentCode,
    required this.isActive,
    required this.studentCount,
    required this.createdAt,
  });
}
