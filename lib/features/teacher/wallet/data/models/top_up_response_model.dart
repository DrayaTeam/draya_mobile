import 'package:json_annotation/json_annotation.dart';

part "top_up_response_model.g.dart";

@JsonSerializable()
class TopUpResponseModel {
  final String transactionId;
  final double amount;
  final String checkoutUrl;

  const TopUpResponseModel({
    required this.transactionId,
    required this.amount,
    required this.checkoutUrl,
  });

  factory TopUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TopUpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopUpResponseModelToJson(this);
}
