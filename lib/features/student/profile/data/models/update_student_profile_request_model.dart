import 'package:json_annotation/json_annotation.dart';

part 'update_student_profile_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateStudentProfileRequestModel {
  final String fullName;
  final String parentGuardianEmail;
  final DateTime? dateOfBirth;

  const UpdateStudentProfileRequestModel({
    required this.fullName,
    required this.parentGuardianEmail,
    this.dateOfBirth,
  });

  factory UpdateStudentProfileRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateStudentProfileRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateStudentProfileRequestModelToJson(this);
}
