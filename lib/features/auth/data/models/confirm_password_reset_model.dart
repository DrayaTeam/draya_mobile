import "package:json_annotation/json_annotation.dart";

part "confirm_password_reset_model.g.dart";

@JsonSerializable()
class ConfirmPasswordResetModel {
  final String token;
  final String newPassword;

  ConfirmPasswordResetModel({
    required this.token,
    required this.newPassword,
  });

  factory ConfirmPasswordResetModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPasswordResetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmPasswordResetModelToJson(this);
}
