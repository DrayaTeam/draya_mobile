// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      classroomId: json['classroomId'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      voteCount: (json['voteCount'] as num).toInt(),
      replyCount: (json['replyCount'] as num).toInt(),
      hasTeacherAnswer: json['hasTeacherAnswer'] as bool,
      hasVoted: json['hasVoted'] as bool,
      isAuthor: json['isAuthor'] as bool,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classroomId': instance.classroomId,
      'authorId': instance.authorId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'voteCount': instance.voteCount,
      'replyCount': instance.replyCount,
      'hasTeacherAnswer': instance.hasTeacherAnswer,
      'hasVoted': instance.hasVoted,
      'isAuthor': instance.isAuthor,
    };
