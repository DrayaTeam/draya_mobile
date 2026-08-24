import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/reply_entity.dart";
import "package:json_annotation/json_annotation.dart";

part "reply_model.g.dart";

@JsonSerializable()
class ReplyModel {
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

  const ReplyModel({
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

  factory ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyModelToJson(this);
}

extension ReplyModelExtension on ReplyModel {
  ReplyEntity toEntity() => ReplyEntity(
    id: id,
    questionId: questionId,
    authorId: authorId,
    authorName: authorName,
    authorRole: authorRole,
    authorProfilePictureUrl: authorProfilePictureUrl,
    content: content,
    imageUrl: imageUrl,
    createdAt: createdAt,
    isTeacherAnswer: isTeacherAnswer,
    isAuthor: isAuthor,
  );
}
