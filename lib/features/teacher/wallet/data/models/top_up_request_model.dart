import 'package:json_annotation/json_annotation.dart';

part "top_up_request_model.g.dart";

@JsonSerializable()
class TopUpRequestModel {
  final double amount;

  const TopUpRequestModel({required this.amount});

  factory TopUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TopUpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopUpRequestModelToJson(this);
}
