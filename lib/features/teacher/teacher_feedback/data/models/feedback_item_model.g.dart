// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackItemModel _$FeedbackItemModelFromJson(Map<String, dynamic> json) =>
    FeedbackItemModel(
      feedbackId: json['feedbackId'] as String,
      studentName: json['studentName'] as String,
      studentAvatarUrl: json['studentAvatarUrl'] as String?,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FeedbackItemModelToJson(FeedbackItemModel instance) =>
    <String, dynamic>{
      'feedbackId': instance.feedbackId,
      'studentName': instance.studentName,
      'studentAvatarUrl': instance.studentAvatarUrl,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
    };
