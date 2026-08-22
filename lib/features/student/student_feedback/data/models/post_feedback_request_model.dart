import "package:json_annotation/json_annotation.dart";

part "post_feedback_request_model.g.dart";

@JsonSerializable()
class PostFeedbackRequestModel {
  final int rating;
  final String comment;

  const PostFeedbackRequestModel({
    required this.rating,
    required this.comment,
  });

  factory PostFeedbackRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PostFeedbackRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostFeedbackRequestModelToJson(this);
}
