import "package:draya_mobile/features/student/student_channel/domain/entity/question_entity.dart";
import "package:json_annotation/json_annotation.dart";

part "question_model.g.dart";

@JsonSerializable()
class QuestionModel {
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

  const QuestionModel({
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

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

extension QuestionModelExtension on QuestionModel {
  QuestionEntity toEntity() => QuestionEntity(
    id: id,
    classroomId: classroomId,
    authorId: authorId,
    content: content,
    createdAt: createdAt,
    voteCount: voteCount,
    replyCount: replyCount,
    hasTeacherAnswer: hasTeacherAnswer,
    hasVoted: hasVoted,
    isAuthor: isAuthor,
  );
}
