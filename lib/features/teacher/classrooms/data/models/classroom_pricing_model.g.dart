// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_pricing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomPricingModel _$ClassroomPricingModelFromJson(
  Map<String, dynamic> json,
) => ClassroomPricingModel(
  classroomId: json['classroomId'] as String,
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String,
  isFree: json['isFree'] as bool,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ClassroomPricingModelToJson(
  ClassroomPricingModel instance,
) => <String, dynamic>{
  'classroomId': instance.classroomId,
  'price': instance.price,
  'currency': instance.currency,
  'isFree': instance.isFree,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
