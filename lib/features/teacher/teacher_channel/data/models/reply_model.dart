import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/reply_entity.dart";
import "package:json_annotation/json_annotation.dart";

part "reply_model.g.dart";

@JsonSerializable()
class ReplyModel {
  final String id;
  final String questionId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final bool isTeacherAnswer;
  final bool isAuthor;

  const ReplyModel({
    required this.id,
    required this.questionId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.isTeacherAnswer,
    required this.isAuthor,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyModelToJson(this);
}

extension ReplyModelExtension on ReplyModel {
  ReplyEntity toEntity() => ReplyEntity(
    id: id,
    questionId: questionId,
    authorId: authorId,
    content: content,
    createdAt: createdAt,
    isTeacherAnswer: isTeacherAnswer,
    isAuthor: isAuthor,
  );
}
