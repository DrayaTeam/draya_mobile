// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) => ReplyModel(
  id: json['id'] as String,
  questionId: json['questionId'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String?,
  authorRole: json['authorRole'] as String?,
  authorProfilePictureUrl: json['authorProfilePictureUrl'] as String?,
  content: json['content'] as String,
  imageUrl: json['imageUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isTeacherAnswer: json['isTeacherAnswer'] as bool,
  isAuthor: json['isAuthor'] as bool,
);

Map<String, dynamic> _$ReplyModelToJson(ReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorRole': instance.authorRole,
      'authorProfilePictureUrl': instance.authorProfilePictureUrl,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'isTeacherAnswer': instance.isTeacherAnswer,
      'isAuthor': instance.isAuthor,
    };
