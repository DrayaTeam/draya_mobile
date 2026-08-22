import "package:draya_mobile/features/teacher/teacher_feedback/domain/entity/classroom_feedback.dart";
import "package:json_annotation/json_annotation.dart";

part "feedback_item_model.g.dart";

@JsonSerializable()
class FeedbackItemModel {
  final String feedbackId;
  final String studentName;
  final String? studentAvatarUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const FeedbackItemModel({
    required this.feedbackId,
    required this.studentName,
    this.studentAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory FeedbackItemModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackItemModelToJson(this);
}

extension FeedbackItemModelMapper on FeedbackItemModel {
  ClassroomFeedback toEntity() => ClassroomFeedback(
        feedbackId: feedbackId,
        studentName: studentName,
        studentAvatarUrl: studentAvatarUrl,
        rating: rating,
        comment: comment,
        createdAt: createdAt,
      );
}
