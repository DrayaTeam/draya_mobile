import "package:json_annotation/json_annotation.dart";

part "payout_account_request_model.g.dart";

@JsonSerializable()
class PayoutAccountRequestModel {
  final int accountType;
  final String accountName;
  final String accountIdentifier;
  final bool isDefault;

  const PayoutAccountRequestModel({
    required this.accountType,
    required this.accountName,
    required this.accountIdentifier,
    required this.isDefault,
  });

  factory PayoutAccountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutAccountRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutAccountRequestModelToJson(this);
}
