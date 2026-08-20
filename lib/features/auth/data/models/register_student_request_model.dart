import "package:json_annotation/json_annotation.dart";
part "register_student_request_model.g.dart";

@JsonSerializable(includeIfNull: false)
class RegisterStudentRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String parentGuardianEmail;
  final DateTime dateOfBirth;

  const RegisterStudentRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    required this.parentGuardianEmail,
    required this.dateOfBirth,
  });

  factory RegisterStudentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterStudentRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterStudentRequestModelToJson(this);
}
