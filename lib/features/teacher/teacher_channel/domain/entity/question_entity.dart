class QuestionEntity {
  final String id;
  final String classroomId;
  final String authorId;
  final String? authorName;
  final String? authorRole;
  final String? authorProfilePictureUrl;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int voteCount;
  final int replyCount;
  final bool hasTeacherAnswer;
  final bool hasVoted;
  final bool isAuthor;

  const QuestionEntity({
    required this.id,
    required this.classroomId,
    required this.authorId,
    this.authorName,
    this.authorRole,
    this.authorProfilePictureUrl,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.voteCount,
    required this.replyCount,
    required this.hasTeacherAnswer,
    required this.hasVoted,
    required this.isAuthor,
  });

  // For updating local state
  QuestionEntity copyWith({
    String? id,
    String? classroomId,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? authorProfilePictureUrl,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    int? voteCount,
    int? replyCount,
    bool? hasTeacherAnswer,
    bool? hasVoted,
    bool? isAuthor,
  }) {
    return QuestionEntity(
      id: id ?? this.id,
      classroomId: classroomId ?? this.classroomId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorProfilePictureUrl:
          authorProfilePictureUrl ?? this.authorProfilePictureUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      voteCount: voteCount ?? this.voteCount,
      replyCount: replyCount ?? this.replyCount,
      hasTeacherAnswer: hasTeacherAnswer ?? this.hasTeacherAnswer,
      hasVoted: hasVoted ?? this.hasVoted,
      isAuthor: isAuthor ?? this.isAuthor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
