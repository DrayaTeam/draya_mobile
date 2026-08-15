class QuestionEntity {
  final String id;
  final String classroomId;
  final String authorId;
  final String content;
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
    required this.content,
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
    String? content,
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
      content: content ?? this.content,
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
