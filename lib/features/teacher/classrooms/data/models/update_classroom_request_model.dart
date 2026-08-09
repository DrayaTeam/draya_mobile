import 'package:json_annotation/json_annotation.dart';

part 'update_classroom_request_model.g.dart';

@JsonSerializable()
class UpdateClassroomRequestModel {
  final String subjectId;
  final String name;
  final bool isActive;

  const UpdateClassroomRequestModel({
    required this.subjectId,
    required this.name,
    required this.isActive,
  });

  factory UpdateClassroomRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateClassroomRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateClassroomRequestModelToJson(this);
}
