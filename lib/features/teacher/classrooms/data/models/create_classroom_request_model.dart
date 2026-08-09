import 'package:json_annotation/json_annotation.dart';

part 'create_classroom_request_model.g.dart';

@JsonSerializable()
class CreateClassroomRequestModel {
  final String subjectId;
  final String name;

  const CreateClassroomRequestModel({
    required this.subjectId,
    required this.name,
  });

  factory CreateClassroomRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateClassroomRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateClassroomRequestModelToJson(this);
}
