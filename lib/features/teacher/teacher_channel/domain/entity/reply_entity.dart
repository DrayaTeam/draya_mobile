class ReplyEntity {
  final String id;
  final String questionId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final bool isTeacherAnswer;
  final bool isAuthor;

  const ReplyEntity({
    required this.id,
    required this.questionId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.isTeacherAnswer,
    required this.isAuthor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplyEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
