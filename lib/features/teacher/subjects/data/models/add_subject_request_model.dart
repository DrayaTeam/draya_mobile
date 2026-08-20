import "package:json_annotation/json_annotation.dart";

part "add_subject_request_model.g.dart";

@JsonSerializable()
class AddSubjectRequestModel {
  final String name;

  const AddSubjectRequestModel({
    required this.name,
  });

  factory AddSubjectRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AddSubjectRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddSubjectRequestModelToJson(this);
}
