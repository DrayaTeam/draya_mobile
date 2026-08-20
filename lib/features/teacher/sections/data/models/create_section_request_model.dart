import "package:json_annotation/json_annotation.dart";

part "create_section_request_model.g.dart";

@JsonSerializable()
class CreateSectionRequestModel {
  final String title;
  final String description;

  const CreateSectionRequestModel({
    required this.title,
    required this.description,
  });

  factory CreateSectionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSectionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSectionRequestModelToJson(this);
}
