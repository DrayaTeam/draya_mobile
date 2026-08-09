class StudentRosterItem {
  final String studentId;
  final String fullName;
  final DateTime enrolledAt;
  final String status;

  const StudentRosterItem({
    required this.studentId,
    required this.fullName,
    required this.enrolledAt,
    required this.status,
  });
}
