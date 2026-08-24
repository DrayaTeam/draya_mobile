import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/question_entity.dart";
import "package:json_annotation/json_annotation.dart";

part "question_model.g.dart";

@JsonSerializable()
class QuestionModel {
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

  const QuestionModel({
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

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

extension QuestionModelExtension on QuestionModel {
  QuestionEntity toEntity() => QuestionEntity(
    id: id,
    classroomId: classroomId,
    authorId: authorId,
    authorName: authorName,
    authorRole: authorRole,
    authorProfilePictureUrl: authorProfilePictureUrl,
    content: content,
    imageUrl: imageUrl,
    createdAt: createdAt,
    voteCount: voteCount,
    replyCount: replyCount,
    hasTeacherAnswer: hasTeacherAnswer,
    hasVoted: hasVoted,
    isAuthor: isAuthor,
  );
}
