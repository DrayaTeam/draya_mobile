import "package:json_annotation/json_annotation.dart";

part "api_error_model.g.dart";

@JsonSerializable()
class ApiErrorModel {
  final ErrorModel? error;
  final bool retry;

  const ApiErrorModel({
    this.retry = false,
    this.error,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}

@JsonSerializable()
class ErrorModel {
  final String? message;
  final String? code;

  const ErrorModel({this.message, this.code});

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
