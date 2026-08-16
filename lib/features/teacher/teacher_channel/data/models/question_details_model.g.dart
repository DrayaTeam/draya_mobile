// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionDetailsModel _$QuestionDetailsModelFromJson(
  Map<String, dynamic> json,
) => QuestionDetailsModel(
  question: QuestionModel.fromJson(json['question'] as Map<String, dynamic>),
  replies: (json['replies'] as List<dynamic>)
      .map((e) => ReplyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionDetailsModelToJson(
  QuestionDetailsModel instance,
) => <String, dynamic>{
  'question': instance.question,
  'replies': instance.replies,
};
