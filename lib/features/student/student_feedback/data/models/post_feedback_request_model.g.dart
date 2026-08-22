// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_feedback_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFeedbackRequestModel _$PostFeedbackRequestModelFromJson(
  Map<String, dynamic> json,
) => PostFeedbackRequestModel(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
);

Map<String, dynamic> _$PostFeedbackRequestModelToJson(
  PostFeedbackRequestModel instance,
) => <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};
