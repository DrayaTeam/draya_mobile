import 'package:json_annotation/json_annotation.dart';

part 'create_question_request_model.g.dart';

@JsonSerializable()
class CreateQuestionRequestModel {
  final String content;

  const CreateQuestionRequestModel({
    required this.content,
  });

  factory CreateQuestionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateQuestionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateQuestionRequestModelToJson(this);
}
