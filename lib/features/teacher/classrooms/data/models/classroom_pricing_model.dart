import 'package:draya_mobile/features/teacher/classrooms/domain/entity/classroom_pricing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'classroom_pricing_model.g.dart';

@JsonSerializable()
class ClassroomPricingModel {
  final String classroomId;
  final double price;
  final String currency;
  final bool isFree;
  final DateTime updatedAt;

  const ClassroomPricingModel({
    required this.classroomId,
    required this.price,
    required this.currency,
    required this.isFree,
    required this.updatedAt,
  });

  factory ClassroomPricingModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomPricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomPricingModelToJson(this);
}

extension ClassroomPricingModelExtension on ClassroomPricingModel {
  ClassroomPricing toEntity() => ClassroomPricing(
    classroomId: classroomId,
    price: price,
    currency: currency,
    isFree: isFree,
    updatedAt: updatedAt,
  );
}
