import 'package:json_annotation/json_annotation.dart';

part 'classroom_checkout_response_model.g.dart';

@JsonSerializable()
class ClassroomCheckoutResponseModel {
  final String checkoutUrl;

  const ClassroomCheckoutResponseModel({
    required this.checkoutUrl,
  });

  factory ClassroomCheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomCheckoutResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomCheckoutResponseModelToJson(this);
}
