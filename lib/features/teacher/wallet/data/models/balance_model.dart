import 'package:json_annotation/json_annotation.dart';

part "balance_model.g.dart";

@JsonSerializable()
class BalanceModel {
  final double earnedBalance;
  final double purchasedBalance;
  final double availableEarnedBalance;

  const BalanceModel({
    required this.earnedBalance,
    required this.purchasedBalance,
    required this.availableEarnedBalance,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceModelToJson(this);
}
