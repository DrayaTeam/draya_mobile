import "package:json_annotation/json_annotation.dart";

part "create_reply_request_model.g.dart";

@JsonSerializable()
class CreateReplyRequestModel {
  final String content;

  const CreateReplyRequestModel({
    required this.content,
  });

  factory CreateReplyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateReplyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReplyRequestModelToJson(this);
}
