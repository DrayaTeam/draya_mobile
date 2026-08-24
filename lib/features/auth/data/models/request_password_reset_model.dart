
import "package:json_annotation/json_annotation.dart";

part "request_password_reset_model.g.dart";

@JsonSerializable()
class RequestPasswordResetModel {
  final String email;

  RequestPasswordResetModel({required this.email});

  factory RequestPasswordResetModel.fromJson(Map<String, dynamic> json) =>
      _$RequestPasswordResetModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPasswordResetModelToJson(this);
}
