import 'package:json_annotation/json_annotation.dart';

part 'set_classroom_pricing_request_model.g.dart';

@JsonSerializable()
class SetClassroomPricingRequestModel {
  final double price;
  final String? currency;

  const SetClassroomPricingRequestModel({
    required this.price,
    this.currency,
  });

  factory SetClassroomPricingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SetClassroomPricingRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SetClassroomPricingRequestModelToJson(this);
}
