import 'package:json_annotation/json_annotation.dart';

part "top_up_request_model.g.dart";

@JsonSerializable()
class TopUpRequestModel {
  final double amount;
  final String redirectionUrl;

  const TopUpRequestModel({
    required this.amount,
    this.redirectionUrl = 'https://draya.com/payment/result',
  });

  factory TopUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TopUpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopUpRequestModelToJson(this);
}
