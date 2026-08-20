import "package:json_annotation/json_annotation.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/reply_model.dart";

part "question_details_model.g.dart";

@JsonSerializable()
class QuestionDetailsModel {
  final QuestionModel question;
  final List<ReplyModel> replies;

  const QuestionDetailsModel({
    required this.question,
    required this.replies,
  });

  factory QuestionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDetailsModelToJson(this);
}
