import "package:json_annotation/json_annotation.dart";

part "classroom_checkout_request_model.g.dart";

@JsonSerializable()
class ClassroomCheckoutRequestModel {
  final String redirectionUrl;

  const ClassroomCheckoutRequestModel({required this.redirectionUrl});

  factory ClassroomCheckoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomCheckoutRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomCheckoutRequestModelToJson(this);
}
