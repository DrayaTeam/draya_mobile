import "package:json_annotation/json_annotation.dart";

part "withdrawal_request_model.g.dart";

@JsonSerializable()
class WithdrawalRequestModel {
  final double amount;
  final String payoutAccountId;

  const WithdrawalRequestModel({
    required this.amount,
    required this.payoutAccountId,
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalRequestModelToJson(this);
}
