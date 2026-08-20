import "package:json_annotation/json_annotation.dart";

part "enroll_classroom_request_model.g.dart";

@JsonSerializable()
class EnrollClassroomRequestModel {
  final String enrollmentCode;

  const EnrollClassroomRequestModel({
    required this.enrollmentCode,
  });

  factory EnrollClassroomRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollClassroomRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollClassroomRequestModelToJson(this);
}
