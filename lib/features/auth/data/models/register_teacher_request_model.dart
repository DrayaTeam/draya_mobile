import "package:json_annotation/json_annotation.dart";
part "register_teacher_request_model.g.dart";

@JsonSerializable(includeIfNull: false)
class RegisterTeacherRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String? phone;
  final String? specialization;
  final String? description;

  const RegisterTeacherRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    this.phone,
    this.specialization,
    this.description,
  });

  factory RegisterTeacherRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterTeacherRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterTeacherRequestModelToJson(this);
}
