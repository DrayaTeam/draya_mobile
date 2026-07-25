import 'package:json_annotation/json_annotation.dart';
part 'register_teacher_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class RegisterTeacherRequestModel {

  final String email;
  final String password;
  final String fullName;
  final String? phone;

  const RegisterTeacherRequestModel({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
  });

  factory RegisterTeacherRequestModel.fromJson(
      Map<String,dynamic> json)
      => _$RegisterTeacherRequestModelFromJson(json);

  Map<String,dynamic> toJson()
      => _$RegisterTeacherRequestModelToJson(this);

}