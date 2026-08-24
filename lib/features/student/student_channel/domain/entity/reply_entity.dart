class ReplyEntity {
  final String id;
  final String questionId;
  final String authorId;
  final String? authorName;
  final String? authorRole;
  final String? authorProfilePictureUrl;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isTeacherAnswer;
  final bool isAuthor;

  const ReplyEntity({
    required this.id,
    required this.questionId,
    required this.authorId,
    this.authorName,
    this.authorRole,
    this.authorProfilePictureUrl,
    required this.content,
    this.imageUrl,
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
