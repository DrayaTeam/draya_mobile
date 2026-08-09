// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_classroom_pricing_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetClassroomPricingRequestModel _$SetClassroomPricingRequestModelFromJson(
  Map<String, dynamic> json,
) => SetClassroomPricingRequestModel(
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$SetClassroomPricingRequestModelToJson(
  SetClassroomPricingRequestModel instance,
) => <String, dynamic>{'price': instance.price, 'currency': instance.currency};
