// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) => ReplyModel(
  id: json['id'] as String,
  questionId: json['questionId'] as String,
  authorId: json['authorId'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isTeacherAnswer: json['isTeacherAnswer'] as bool,
  isAuthor: json['isAuthor'] as bool,
);

Map<String, dynamic> _$ReplyModelToJson(ReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'authorId': instance.authorId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'isTeacherAnswer': instance.isTeacherAnswer,
      'isAuthor': instance.isAuthor,
    };
