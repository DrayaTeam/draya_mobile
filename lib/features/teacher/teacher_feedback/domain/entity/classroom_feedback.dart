class ClassroomFeedback {
  final String feedbackId;
  final String studentName;
  final String? studentAvatarUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ClassroomFeedback({
    required this.feedbackId,
    required this.studentName,
    this.studentAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
