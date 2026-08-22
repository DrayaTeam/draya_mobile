import "package:json_annotation/json_annotation.dart";

part "update_teacher_request_model.g.dart";

@JsonSerializable()
class UpdateTeacherRequestModel {
  final String fullName;
  final String phone;
  final String specialization;
  final String description;

  UpdateTeacherRequestModel({
    required this.fullName,
    required this.phone,
    required this.specialization,
    required this.description,
  });

  factory UpdateTeacherRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateTeacherRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTeacherRequestModelToJson(this);
}
